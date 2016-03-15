## Setup

    ssh root@host

    apt-get install -y git

    useradd -g users -G sudo -m -s /bin/bash bench

    visudo # add NOPASSWD: to %sudo line before the last ALL

    su - bench

    mkdir ~/.ssh
    cat >~/.ssh/authorized_keys # paste your primary key and press Ctrl-D

    git clone https://github.com/mwpastore/dalli-bench.git ~/src/dalli-bench
    src/dalli-bench/setup.sh # this will reboot the machine

    ssh -A bench@host

## Benchmarking

1.  Start the server

        ./server.sh

1.  Wait for it to be ready

1.  Run the benchmark

        ./bench.sh

## Contributing

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global push.default simple
    git remote set-url origin git@github.com:mwpastore/dalli-bench.git

## TODO

* kgio+connection_pool shifts the bottleneck to Memcached. Can we bench against
  a ring?
* Can't quite get JRuby to max out the CPUs and/or Memcached. What other tuning
  can we do?
