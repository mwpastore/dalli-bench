    apt-get install git

    useradd -g users -G sudo -m -s /bin/bash bench

    su - bench

    mkdir ~/.ssh
    cat >~/.ssh/authorized_keys # paste your primary key and press Ctrl-D

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"

    git clone git@github.com:mwpastore/dalli-bench.git
    cd dalli-bench
    ./setup.sh
