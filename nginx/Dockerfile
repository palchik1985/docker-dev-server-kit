FROM nginx:mainline-alpine

# Switch to use a non-root user from here on
USER 1000

# Add application
WORKDIR /var/www

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]