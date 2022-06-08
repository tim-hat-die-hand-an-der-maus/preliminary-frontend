FROM node:18-alpine3.15 as builder

WORKDIR /usr/src/app

COPY babel.config.js .
COPY package.json .
COPY yarn.lock .
COPY src/ src/
COPY public/ public/

RUN sed -i -e "s#__commit_sha__#$(echo ${GITHUB_SHA})#g" src/App.vue

RUN yarn install
RUN yarn build

FROM nginx:1.22-alpine

COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
