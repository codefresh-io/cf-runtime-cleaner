FROM docker:17.03

#install curl and bash
RUN apk --no-cache add \
    bash \
    curl

COPY docker-gc run-docker-gc.sh clean-loggers.sh /

RUN chmod +x docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

CMD ["./run-docker-gc.sh"]
