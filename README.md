## Setup

    ssh root@host

    apt-get install -y git

    useradd -g users -G sudo -m -s /bin/bash bench

    visudo # add NOPASSWD: before the last ALL

    su - bench

    mkdir ~/.ssh
    cat >~/.ssh/authorized_keys # paste your primary key and press Ctrl-D

    logout

    ssh -A bench@host

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"

    git clone git@github.com:mwpastore/dalli-bench.git ~/src/dalli-bench
    src/dalli-bench/setup.sh

## TODO

* kgio+connection_pool shifts the bottleneck to Memcached. Can we bench against
  a ring?
