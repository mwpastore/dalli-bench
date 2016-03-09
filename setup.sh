#!/bin/bash -ex

cd $(dirname $0)

sudo apt-add-repository -y ppa:brightbox/ruby-ng

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install \
  build-essential \
  libreadline-dev \
  libssl-dev \
  libedit-dev \
  libncurses5-dev \
  memcached \
  openjdk-7-jre-headless \
  haveged \
  clang-3.5 \
  ruby2.2 \
  ruby2.2-dev

sudo ln -sf /usr/bin/llvm-config-3.5 /usr/bin/llvm-config # why

sudo sed -i -e 's/^-m [0-9]*/-m 15872/' /etc/memcached.conf

cat <<EOF | sudo dd of=/etc/sysctl.conf oflag=append conv=notrunc
vm.swappiness = 0
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_congestion_control = cubic
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.ipv4.tcp_rmem = 8192 873800 8388608
net.ipv4.tcp_wmem = 4096 655360 8388608
net.ipv4.tcp_mem = 8388608 8388608 8388608
net.ipv4.tcp_max_tw_buckets = 6000000
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_max_orphans = 262144
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_slow_start_after_idle = 0
EOF

cat <<EOF | sudo dd of=/etc/security/limits.conf oflag=append conv=notrunc
bench      hard    nofile      500000
bench      soft    nofile      500000
EOF

mkdir -p ~/src
pushd ~/src
git clone https://github.com/wg/wrk.git
pushd wrk
make
sudo ln -sf ~/src/wrk/wrk /usr/local/bin/wrk
popd
popd

cat <<EOF >~/.gemrc
install: --no-document
update: --no-document
EOF

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

cat <<'EOF' >>~/.bashrc
export PATH="$HOME/.rbenv/bin:$HOME/.gem/ruby/2.2.0/bin:$PATH"
eval "$(rbenv init -)"
EOF

export PATH="$HOME/.rbenv/bin:$HOME/.gem/ruby/2.2.0/bin:$PATH"
eval "$(rbenv init -)"

rbenv rehash
gem install --user-install bundler

#rbenv install jruby-9.0.5.0
#rbenv install jruby-1.7.24
#rbenv install rbx-2.5.8

sudo reboot
