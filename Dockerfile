FROM alpine:edge AS glab-www

RUN apk add --no-cache --virtual .glab-www \
    nginx \
    tini

RUN mkdir -p /run/nginx && \
    touch /run/nginx/nginx.pid && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /run/nginx/nginx.pid

COPY --chown=nginx:nginx ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx ./nginx/html /usr/share/nginx/html

EXPOSE 8080 8443
VOLUME /usr/share/nginx/html
VOLUME /etc/nginx

USER nginx
WORKDIR /usr/share/nginx
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "nginx", "-g", "daemon off;" ]