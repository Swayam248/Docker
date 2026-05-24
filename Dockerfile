# Base image (lightweight Node.js runtime)
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package files first (for caching optimization)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application code
COPY . .

# Expose application port
EXPOSE 3000

# Default command to run app
CMD ["node", "app.js"]

#######################################################################################################

# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y gcc

# Copy requirements first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create non-root user
RUN useradd -m appuser

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Run application
CMD ["python", "app.py"]

#################################################################################

# -------- Stage 1: Build --------
FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Build production assets
RUN npm run build


# -------- Stage 2: Production --------
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Expose port
EXPOSE 3000

# Start app
CMD ["node", "dist/server.js"]
