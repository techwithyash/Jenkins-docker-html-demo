# Use the official Nginx Alpine image as the base
# Alpine is a lightweight Linux distribution, making the image smaller and faster
FROM nginx:alpine

# Copy our custom HTML file to the Nginx default web directory
# Nginx serves files from /usr/share/nginx/html/ by default
COPY index.html /usr/share/nginx/html/

# Expose port 80 to allow external access to the web server
# This is the standard HTTP port
EXPOSE 80

# No CMD needed - the nginx:alpine base image already has the command to start Nginx
