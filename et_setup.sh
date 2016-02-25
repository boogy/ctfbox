#!/bin/bash

## create a user
getent passwd ctf | sudo useradd -m -s /bin/bash ctf
sudo chown -R ctf: /home/ctf && sudo chmod 4750 /home/ctf
sudo mkdir -p /home/ctf/tools && sudo mkdir -p /etc/sudoeres.d/
sudo echo "ctf ALL=(ALL) NOPASSWD:ALL" > /etc/sudoeres.d/ctf

# Updates
sudo apt-get -y update
sudo apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get -y -q install git sudo \
        python2.7 python-pip python-dev python3-pip python3-dev \
        tmux gdb gdb-multiarch foremost ipython stow build-essential \
        ltrace strace socat tcpdump john hydra vim curl wget

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static 'binfmt*' \
    libc6-armhf-armel-cross debian-keyring \
    debian-archive-keyring emdebian-archive-keyring

tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF
sudo apt-get -y install libc6-mipsel-cross libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list
sudo apt-get update

# Install Binjitsu
sudo apt-get -y install python2.7 python-pip python-dev git
sudo pip install --upgrade git+https://github.com/binjitsu/binjitsu.git

cd /home/ctf
mkdir -p /home/ctf/tools

# Install pwndbg
cd /home/ctf/tools
git clone https://github.com/zachriggle/pwndbg
echo "#source ~/tools/pwndbg/gdbinit.py" >> ~/.gdbinit


## Install peda
cd /home/ctf/tools
git clone https://github.com/longld/peda.git
echo "source ~/tools/peda/peda.py" >> /home/ctf/.gdbinit

# Capstone for pwndbg
cd /home/ctf/tools
git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

# pycparser for pwndbg
sudo pip3 install pycparser # Use pip3 for Python3

# Install radare2
cd /home/ctf/tools
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

# Install binwalk
cd /home/ctf/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
sudo apt-get install squashfs-tools

# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd /home/ctf/tools
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
cd fmk_099/src
./configure
make

# Uninstall capstone
sudo pip2 uninstall capstone -y

# Install correct capstone
cd /home/ctf/tools/capstone/bindings/python
sudo python setup.py install

# Personal config
cd /home/ctf
git clone https://github.com/boogy/dotfiles.git

# Install Angr
cd /home/ctf/tools
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
sudo pip install angr --upgrade

# Install american-fuzzy-lop
sudo apt-get -y install clang llvm
cd /home/ctf/tools
wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xzvf afl-latest.tgz
rm afl-latest.tgz
(
  cd afl-*
  make
  # build clang-fast
  (
    cd llvm_mode
    make
  )
  sudo make install
)

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -y install libc6-dev-i386

# Install apktool - from https://github.com/zardus/ctf-tools
apt-get update
apt-get install -y default-jre
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar
mv apktool_2.0.2.jar /bin/apktool.jar
mv apktool /bin/
chmod 755 /bin/apktool
chmod 755 /bin/apktool.jar

# Install preeny
cd /home/ctf/tools
git clone --depth 1 https://github.com/zardus/preeny
PATH=$PWD/../crosstool/bin:$PATH

cd preeny
for i in ../../crosstool/bin/*-gcc
do
    t=$(basename $i)
    CC=$t make -j $(nproc) -i
done
PLATFORM=-m32 setarch i686 make -i
mv x86_64-linux-gnu i686-linux-gnu
make -i

# Install Pillow
sudo apt-get build-dep python-imaging
sudo apt-get install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
sudo pip install Pillow

# Install r2pipe
sudo pip install r2pipe

# Install angr-dev
cd /home/ctf/tools
git clone https://github.com/angr/angr-dev
cd angr-dev

# Install ROPGadget
cd /home/ctf/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

## Install Z3 Prover
cd /home/ctf/tools
git clone https://github.com/Z3Prover/z3.git
cd z3
python scripts/mk_make.py
cd build
make install
python ../scripts/mk_make.py --python


