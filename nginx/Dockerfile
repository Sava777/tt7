FROM gliderlabs/alpine:3.3

RUN apk-install nginx
COPY ./conf /etc/nginx/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]