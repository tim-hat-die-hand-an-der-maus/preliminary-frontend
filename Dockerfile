FROM nginx:1.21-alpine
EXPOSE 80

ADD dist /usr/share/nginx/html
