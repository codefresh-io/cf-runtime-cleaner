FROM docker:17.03

#install docker
#RUN curl -sSL https://get.docker.com/ | sh
RUN apk --no-cache add \
    bash \
    curl

# COPY ./docker-image-clean.sh docker-image-clean.sh
COPY docker-prune docker-gc run-docker-gc.sh  /
COPY /etc/ /etc/
RUN chmod +x docker-prune docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

# ENV CLEAN_PERIOD 24h
# ENV PROTECTED_IMAGE_PREFIX codefresh-running/

CMD ["./run-docker-gc.sh"]
