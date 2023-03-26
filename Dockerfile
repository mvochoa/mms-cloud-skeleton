FROM node:alpine AS builder

WORKDIR /app

RUN yarn add vite

ADD package.json /app/package.json

# Installing packages
RUN yarn install

ADD . /app

# Building TypeScript files
RUN yarn build-only

EXPOSE 3000

CMD [ "yarn", "dev" ]

FROM nginx:stable-alpine

ENV NGINX_PORT=3000

COPY --from=builder /app/dist /usr/share/nginx/html

RUN mkdir /etc/nginx/templates/ \
    && sed 's/listen       80/listen       ${NGINX_PORT}/g' /etc/nginx/conf.d/default.conf > /etc/nginx/templates/default.conf.template

EXPOSE 3000
