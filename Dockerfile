FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-workstation"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
