FROM node:17-alpine3.15 as builder

ARG GITHUBSHA

WORKDIR /usr/src/app

COPY babel.config.js .
COPY package.json .
COPY yarn.lock .
COPY src/ src/
COPY public/ public/

RUN sed -i -e "s#__commit_sha__#$GITHUBSHA#g" src/App.vue

RUN yarn install
RUN yarn build

FROM nginx:1.23-alpine

COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
