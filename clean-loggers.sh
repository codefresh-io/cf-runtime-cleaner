#!/bin/bash

set -euo pipefail

# gets a container processId label value
function getPID() {
    echo $(docker inspect $1 --format='{{index .Config.Labels "io.codefresh.processId"}}')
}

function findDanglingLoggers() {
    local logger_containers=$(docker ps -f label=io.codefresh.repo.name=cf-container-logger -q)
    local user_containers=$(docker ps -f label=io.codefresh.visibility=user -q)
    
    for l in $logger_containers; do
        local l_pid=$(getPID $l)
        for u in $user_containers; do
            local u_pid=$(getPID $u)
            local dangling="true"
            if [[ "$l_pid" == "$u_pid" ]]; then
                local dangling=false
                break
            fi
        done

        if [[ $dangling == "true" ]]; then
            echo $l >> $dangling_loggers;
        fi
    done
}

# loops through all logger containers and tries to find
# user containers with matching processId, if notthing found - marks logger as dangling
function cleanDanglingLoggers() {
    echo -e "Looking for dangling logger containers...\n"

    dangling_loggers=$(mktemp)
    findDanglingLoggers

    if [[ $(cat $dangling_loggers) ]]; then
        echo -e "The following dangling logger containers will be cleaned:\n"
        cat $dangling_loggers
        for dl in $(cat $dangling_loggers); do
            docker unpause $dl 2>/dev/null || true
            docker rm -f $dl 1>/dev/null
        done
    else
        echo -e "No dangling loggers found\n"
    fi
}

cleanDanglingLoggers