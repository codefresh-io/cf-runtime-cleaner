FROM docker:20.10

#install curl and bash 
RUN apk --no-cache add \
    bash \
    curl

RUN adduser -D -h /home/cfu -s /bin/bash cfu \
    && chgrp -R $(id -g cfu) /cf-api /root \
    && chmod -R g+rwX /cf-runtime-cleaner /root
USER cfu

COPY docker-gc run-docker-gc.sh clean-loggers.sh /

RUN chmod +x docker-gc run-docker-gc.sh

ENV CLEAN_INTERVAL 3600

CMD ["./run-docker-gc.sh"]
