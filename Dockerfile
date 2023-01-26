FROM docker:20.10

#install curl and bash 
RUN apk --no-cache add \
    bash \
    curl

# add user
RUN addgroup --gid 3000 runtime-cleaner && \
    adduser --uid 3000 --gecos "" --disabled-password \
    --ingroup runtime-cleaner \
    --home /home/runtime-cleaner \
    --shell /bin/bash runtime-cleaner

WORKDIR /home/runtime-cleaner

COPY docker-gc run-docker-gc.sh clean-loggers.sh ./
RUN chmod +x docker-gc run-docker-gc.sh


RUN chown -R runtime-cleaner:runtime-cleaner /home/runtime-cleaner && \
    chmod 755 /home/runtime-cleaner

USER runtime-cleaner:runtime-cleaner

ENV CLEAN_INTERVAL 3600

CMD ["./run-docker-gc.sh"]
