# Dockerfile - static web
FROM nginx:stable-alpine
LABEL maintainer="yourname@example.com"
# Remove default index and copy site
RUN rm -rf /usr/share/nginx/html/*
COPY app/ /usr/share/nginx/html/
# Add simple nginx config to proxy /api to api:5000 (used in docker-compose / k8s)
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
