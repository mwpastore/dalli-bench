#!/bin/bash

export THREAD_DEPTH=400
PORT=9292

function bench {
  local time=$1

  wrk -t12 -c$THREAD_DEPTH -d$time -H'Cookie: rack.session=12345' http://localhost:$PORT
}
