FROM ubuntu:latest
MAINTAINER boogy <theboogymaster@gmail.com>

RUN dpkg --add-architecture i386 && \
        apt-get update && \
        apt-get -yq install \
        python2.7 \
        python2.7-dev \
        python-pip \
        python3-pip \
        python3-dev \
        python-dbg \
        apt-utils \
        git \
        sudo \
        p7zip \
        autoconf \
        libssl-dev \
        libpcap-dev \
        libffi-dev \
        clang \
        nasm \
        tmux \
        gdb \
        gdb-multiarch \
        gdbserver \
        foremost \
        ipython \
        stow \
        build-essential \
        virtualenvwrapper \
        ltrace \
        strace \
        socat \
        tcpdump \
        john \
        hydra \
        vim \
        curl \
        wget \
        nmap \
        gcc \
        g++ \
        netcat \
        openssh-server \
        openssh-client \
        lsof \
        libc6:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        libc6-dev-i386

RUN useradd -m -s /bin/bash ctf && \
        chown -R ctf: /home/ctf && \
        chmod 4750 /home/ctf && \
        mkdir -p /home/ctf/tools && \
        mkdir -p /etc/sudoeres.d/ && \
        echo "ctf ALL=(ALL) NOPASSWD:ALL" > /etc/sudoeres.d/ctf && \
        echo "kernel.yama.ptrace_scope = 0" > /etc/sysctl.d/10-ptrace.conf

COPY setup.sh /home/ctf/setup.sh

RUN chmod +x /home/ctf/setup.sh && \
        bash /home/ctf/setup.sh && \
        chown -R ctf.ctf /home/ctf/tools

EXPOSE 22 1337 3002 3003 4000

USER ctf

WORKDIR /home/ctf

CMD ["/bin/bash", "-i"]
