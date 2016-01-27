FROM codefresh/buildpacks:essential

#install docker
RUN curl -sSL https://get.docker.com/ | sh

COPY ./docker-image-clean.sh docker-image-clean.sh
RUN chmod +x docker-image-clean.sh

ENV CLEAN_INTERVAL 30
ENV CLEAN_PERIOD 24h

CMD ./docker-image-clean.sh