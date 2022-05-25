FROM nginx:1.22-alpine
EXPOSE 80

ADD dist /usr/share/nginx/html
