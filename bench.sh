#!/bin/bash

export THREAD_DEPTH=400
PORT=9292

cd $(dirname $0)
bundle install --jobs=4

jruby -J-Xmn512m -J-Xms2048m -J-Xmx2048m -J-server \
  -S rackup -s Puma -O Threads=$THREAD_DEPTH:$THREAD_DEPTH -p $PORT \
  -E production -r ./server -b 'run DalliBench' &

puma_pid=$!

echo " ** waiting for jruby..."
sleep 10

function bench {
  local time=$1

  wrk -t12 -c$THREAD_DEPTH -d$time -H'Cookie: rack.session=12345' http://localhost:$PORT
}

echo " ** warming up..."
bench 60s >/dev/null 2>&1

echo " ** sleeping..."
sleep 10

bench 60s

kill $puma_pid
wait $puma_pid
