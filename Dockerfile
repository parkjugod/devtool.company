FROM node:14.16.1-alpine3.10 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=operation
COPY . .
RUN npm run build

FROM nginx:1.18.0-alpine as production-stage
COPY  ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]