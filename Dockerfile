# Use the lightweight Nginx Alpine image
FROM nginx:alpine

# Copy the HTML file to the default Nginx web root directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
