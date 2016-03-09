#!/bin/bash

#cd $(dirname $0)
#bundle install

function bench {
  local time=$1

  wrk -t12 -c400 -d$time http://localhost:4567
}

echo "warming up..."
bench 30s >/dev/null 2>&1

sleep 10

bench 60s
