#!/bin/sh -ex

cd $(dirname $0)

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install \
  build-essential \
  libreadline-dev \
  libssl-dev \
  memcached \
  openjdk-7-jre-headless \
  haveged

sudo sed -i -e 's/^-m [0-9]*/-m 15872/' /etc/memcached.conf

cat <<EOF >>/etc/sysctl.conf
vm.swappiness = 0
net.ipv4.tcp_max_syn_backlog = 8102
net.ipv4.ip_local_port_range = 1024 65535
EOF

cat <<EOF | sudo dd of=/etc/security/limits.conf oflag=append
root      hard    nofile      500000
root      soft    nofile      500000
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
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

rbenv install jruby-9.0.5.0
rbenv global jruby-9.0.5.0
gem install bundler

sudo reboot
