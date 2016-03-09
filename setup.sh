#!/bin/sh

apt-get update
apt-get -y upgrade
apt-get -y install \
  build-essential \
  libreadline-dev \
  libssl-dev \
  memcached

cat <<EOF >~/.gemrc
install: --no-document
update: --no-document
EOF

gem install --include-dependencies bundler

sed -i -e 's/^-m [0-9]*/-m 15872/' /etc/memcached.conf
service memcached restart

mkdir -p /usr/local/src
cd /usr/local/src
git clone https://github.com/wg/wrk.git
cd wrk
make
ln -sf /usr/local/src/wrk /usr/local/bin/wrk
