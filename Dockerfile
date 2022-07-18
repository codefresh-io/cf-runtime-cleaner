FROM docker:20.10

RUN apk --no-cache add \
    bash \
    curl

COPY docker-gc run-docker-gc.sh clean-loggers.sh /

RUN chmod +x docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

RUN adduser -D -h /home/cfu -s /bin/bash cfu \
    && chown -R $(id -g cfu) /var /run /lib \
    && chmod -R g+rwX /var /run /lib

USER cfu

CMD ["./run-docker-gc.sh"]
