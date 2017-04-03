#!/usr/bin/env bash

# Runs docker-gc periodically

DOCKER_GC=$(dirname $0)/docker-gc
CLEAN_INTERVAL=${CLEAN_INTERVAL:=1h}

echo -e "#### Starting $0 at `date` \n DOCKER_GC = ${DOCKER_GC} \nCLEAN_INTERVAL = ${CLEAN_INTERVAL} \n"
while true
do
    $DOCKER_GC
	echo "Going to sleep for ${CLEAN_INTERVAL}..."    
    sleep ${CLEAN_INTERVAL}
done
