# Use an official Node.js runtime as a base image
FROM node:latest AS build

# Set the working directory in the container
WORKDIR /insurance/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install dependencies
RUN npm install

# Copy the entire project directory into the container
COPY . .

# Build the Angular app for production
RUN ng build --prod

# Use a lightweight Node.js image for the production environment
FROM nginx:alpine

# Copy the built Angular app from the 'build' stage to the NGINX directory
COPY --from=build /usr/src/app/dist/* /usr/share/nginx/html/

# Expose port 80 to the outside world
EXPOSE 80

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]
