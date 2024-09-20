FROM nginx:stable-alpine

WORKDIR /app

COPY ./frontend.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
