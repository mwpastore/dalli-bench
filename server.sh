#!/bin/bash

cd $(dirname $0)

source common.sh

echo " ** installing gems"
bundle install --jobs=4

echo " ** waiting for juby"
  #--profile.api --profile.json --profile.out head.json \
jruby -J-Xmn512m -J-Xms2048m -J-Xmx2048m -J-server \
  -Xcompile.invokedynamic=true -G \
  -S rackup -s Puma -O Threads=$THREAD_DEPTH:$THREAD_DEPTH -p $PORT \
  -E production &

puma_pid=$!
sleep 10

echo " ** warming up..."
bench 60s >/dev/null 2>&1

echo " ** ready!"

trap "kill $puma_pid" INT
wait $puma_pid
