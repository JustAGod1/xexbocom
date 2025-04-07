# Stage 1: Build the Vite project
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first for better caching
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

# Install dependencies (use the appropriate package manager)
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the Vite project
RUN npm run build

# Stage 2: Serve the built files with Nginx
FROM nginx:alpine

# Copy the built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]