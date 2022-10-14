#!/bin/bash
set -euo pipefail
cd $(dirname $0)

docker build -t cypress-lambda-example .
container_id=$(
    docker run -it -p 9000:8080 \
    --read-only \
    --mount type=tmpfs,destination=/tmp,tmpfs-size=536870912 \
    --ipc none \
    -u 1000 \
    --detach \
    cypress-lambda-example)
# wait for container to start up
sleep 3

# test function
curl -X POST --fail "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

docker logs "$container_id"
# Stop lambda container
docker kill "$container_id"

