#!/bin/bash

cd $(dirname $0)

source common.sh

echo " ** installing gems"
bundle install --jobs=4

jruby -J-Xmn512m -J-Xms2048m -J-Xmx2048m -J-server \
  -S rackup -s Puma -O Threads=$THREAD_DEPTH:$THREAD_DEPTH -p $PORT \
  -E production -r ./app -b 'run DalliBench' &

puma_pid=$!

echo " ** waiting for juby"
sleep 10

echo " ** warming up..."
bench 60s >/dev/null 2>&1

echo " ** ready!"

wait $puma_pid
