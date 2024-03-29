FROM docker:20.10

#install curl and bash 
RUN apk --no-cache add \
    bash \
    curl

RUN rm /usr/local/libexec/docker/cli-plugins/*

COPY docker-gc run-docker-gc.sh clean-loggers.sh /

RUN chmod +x docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

CMD ["./run-docker-gc.sh"]
