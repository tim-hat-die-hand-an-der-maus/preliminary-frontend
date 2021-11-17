FROM nginx:1.19-alpine
EXPOSE 80

ADD dist /usr/share/nginx/html
