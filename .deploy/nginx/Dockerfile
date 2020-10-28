FROM nginx:1.17-alpine

ENV USER=nginx

RUN chown -R $USER:$USER /etc/nginx/conf.d

USER $USER

COPY --chown=$USER configs/nginx.conf /etc/nginx/nginx.conf
COPY --chown=$USER configs/templates/default.conf /etc/nginx/conf.d/templates/default.conf

COPY --chown=$USER docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
