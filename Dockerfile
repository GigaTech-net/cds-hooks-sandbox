#stage 1
FROM nikolaik/python-nodejs:python3.11-nodejs14 as node
WORKDIR /app
COPY . .
RUN npm ci
ARG ENV
RUN npm run set-env-$ENV
RUN npm run build-$ENV

#stage 2
FROM nginx:alpine
ARG APP_BASE_URL
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=node /app/build /usr/share/nginx/html${APP_BASE_URL}

EXPOSE 8080