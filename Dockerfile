FROM ubuntu:latest
MAINTAINER boogy <theboogymaster@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -yq install \
    build-essential \
    python2.7 \
    python2.7-dev \
    python-dbg \
    python-imaging \
    python-pycryptopp \
    python-pyside \
    python-dev \
    python-dev \
    python-pip \
    python-virtualenv \
    virtualenvwrapper \
    python3 \
    python3-pip \
    python3-dev \
    libqt4-dev \
    libxml2-dev \
    libxslt1-dev \
    libgraphviz-dev \
    libjpeg8 \
    libjpeg62-dev \
    libfreetype6 \
    libfreetype6-dev \
    apt-utils \
    default-jre \
    libboost-all-dev \
    git \
    sudo \
    p7zip \
    autoconf \
    libssl-dev \
    libpcap-dev \
    libffi-dev \
    libqt4-dev \
    graphviz-dev \
    cmake \
    clang \
    llvm \
    nasm \
    tmux \
    gdb \
    gdb-multiarch \
    gdbserver \
    foremost \
    ipython \
    stow \
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
    gcc-multilib \
    g++-multilib \
    netcat \
    openssh-server \
    openssh-client \
    lsof \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386 \
    squashfs-tools \
    apktool \
    libimage-exiftool-perl \
    qemu \
    qemu-user \
    qemu-user-static

## super root password
RUN /bin/echo -e "toor\ntoor"|passwd root

## setup a user
RUN useradd -m -s /bin/bash ctf \
    && usermod -aG sudo ctf \
    && /bin/echo -e "ctf\nctf"|passwd ctf \
    && chmod 4750 /home/ctf \
    && mkdir -p /home/ctf/tools \
    && chown -R ctf: /home/ctf \
    && mkdir -p /etc/sudoers.d \
    && echo "ctf ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ctf \
    && echo "kernel.yama.ptrace_scope = 0" > /etc/sysctl.d/10-ptrace.conf, \
    && sysctl -p

## clone my dotfiles
RUN git clone https://github.com/boogy/dotfiles.git /home/ctf/dotfiles

## Other python cool pip modules
RUN pip2 install --upgrade pip \
    && pip2 install --upgrade r2pipe \
    && pip2 install --upgrade Pillow \
    && pip2 install --upgrade distorm3 \
    && pip2 install --upgrade pycrypto \
    && pip2 install --upgrade git+https://github.com/hellman/xortool.git

## Install Binjitsu
RUN pip install --upgrade git+https://github.com/Gallopsled/pwntools.git

## Install peda
RUN git clone https://github.com/longld/peda.git /home/ctf/tools/peda \
    && echo -en "define load_peda\n  source /home/ctf/tools/peda/peda.py\nend\n" >> /home/ctf/.gdbinit

## Install pwndbg
RUN git clone https://github.com/zachriggle/pwndbg /home/ctf/tools/pwndbg \
    && echo -en "\ndefine load_pwndbg\n  source /home/ctf/tools/pwndbg/gdbinit.py\nend\n" >> /home/ctf/.gdbinit \
    && pip3 install pycparser

## Install capstone
RUN git clone https://github.com/aquynh/capstone /home/ctf/tools/capstone \
    && cd /home/ctf/tools/capstone \
    && ./make.sh \
    && ./make.sh install \
    && cd /home/ctf/tools/capstone/bindings/python \
    && python3 setup.py install \
    && python2 setup.py install

## Install radare2
RUN git clone https://github.com/radare/radare2 /home/ctf/tools/radare2 \
    && cd /home/ctf/tools/radare2 \
    && ./sys/install.sh

## Install binwalk
RUN git clone https://github.com/devttys0/binwalk /home/ctf/tools/binwalk \
    && cd /home/ctf/tools/binwalk \
    && python setup.py install

## Uninstall capstone for python2
#RUN pip2 uninstall capstone -y \
#    && cd /home/ctf/tools/capstone/bindings/python \
#    && python3 setup.py install

## Install american-fuzzy-lop
RUN wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz -O /home/ctf/tools/afl-latest.tgz \
    && cd /home/ctf/tools/ \
    && tar -xzvf afl-latest.tgz \
    && rm afl-latest.tgz \
    && (cd afl-*;make;(cd llvm_mode;make);make install)

## Install angr
#RUN git clone https://github.com/angr/angr-dev /home/ctf/tools/angr-dev \
#    && cd /home/ctf/tools/angr-dev \
#    && ./setup.sh -i -e angr
RUN pip2 install angr

# RUN git clone https://github.com/angr/angr-dev /home/ctf/tools/angr-dev \
#     && cd /home/ctf/tools/angr-dev \
#     && . /usr/local/bin/virtualenvwrapper.sh \
#     && mkvirtualenv angr \
#     && echo "I know this is a bad idea."|./setup.sh -i \
#     && deactivate
#     # && ./setup.sh -i -e angr

## Install rp++
RUN apt-get install -yq clang-3.5 \
    && export CC=/usr/bin/clang-3.5 \
    && export CXX=/usr/bin/clang++-3.5 \
    && cd /home/ctf/tools \
    && git clone https://github.com/0vercl0k/rp.git \
    && cd rp \
    && git checkout next \
    && git submodule update --init --recursive \
    && sed -i 's/find_package(Boost 1.59.0 COMPONENTS flyweight)/find_package(Boost)/g' CMakeLists.txt \
    && mkdir build \
    && cd build \
    && cmake ../ \
    && make \
    && cp ../bin/rp-lin-x64 /usr/local/bin/


## Install ROPGadget
RUN git clone https://github.com/JonathanSalwan/ROPgadget /home/ctf/tools/ROPgadget \
    && cd /home/ctf/tools/ROPgadget \
    && python setup.py install


## Install Z3 Prover
RUN git clone https://github.com/Z3Prover/z3.git /home/ctf/tools/z3 \
    && cd /home/ctf/tools/z3 \
    && python scripts/mk_make.py --python \
    && cd build \
    && make install

## Install keystone engine
RUN git clone https://github.com/keystone-engine/keystone.git /home/ctf/tools/keystone \
    && cd /home/ctf/tools/keystone \
    && mkdir build \
    && cd build \
    && ../make-share.sh \
    && make install \
    && ldconfig \
    && cd /home/ctf/tools/keystone/bindings/python \
    && make install

## Install manticore
#RUN git clone --depth 1 https://github.com/trailofbits/manticore.git \
#    && cd manticore \
#    && pip install --no-binary capstone .

EXPOSE 22 1337 3002 3003 4000
USER ctf
WORKDIR /home/ctf

CMD ["/bin/bash", "-i"]
