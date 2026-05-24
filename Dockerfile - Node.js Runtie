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
