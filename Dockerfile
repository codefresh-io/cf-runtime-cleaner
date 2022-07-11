FROM docker:20.10

#install curl and bash 
RUN apk --no-cache add \
    bash \
    curl

COPY docker-gc run-docker-gc.sh clean-loggers.sh /

RUN chmod +x docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

RUN adduser -D -h /home/cfu -s /bin/bash cfu


USER cfu

CMD ["./run-docker-gc.sh"]
