# cf-runtime-cleaner
Cleanup images for runtime machines (runner/builder)

Original docker-gc forked from https://github.com/spotify/docker-gc

Env vars:
GRACE_PERIOD_SECONDS - we will clean images older than GRACE_PERIOD_SECONDS 
                       if and only if there is no container for that image
                       default 86400 (1day)

CLEAN_INTERVAL - cleaning runs every $CLEAN_INTERVAL . Default = 3600

RM_DRY_RUN=${RM_DRY_RUN:=1} - Dry run for Containers
RMI_DRY_RUN=${RMI_DRY_RUN:=0} - Dry run for Images

see ./docker-gc for other possible envs

should be ran with mounting docker socket:

docker run -d --name rt-cleaner -v /var/run/docker.sock:/var/run/docker.sock:rw codefresh/cf-runtime-cleaner:latest ./docker-gc


Add to crontab (root):

#codefresh runtime-cleaner
20 4 * * * docker run --rm --name rt-cleaner -v /var/run/docker.sock:/var/run/docker.sock:rw --label io.codefresh.owner=codefresh -e GRACE_PERIOD_SECONDS=86400 --cpu-shares=10 codefresh/cf-runtime-cleaner:latest ./docker-gc >> /var/log/rt-cleaner.log 2>&1