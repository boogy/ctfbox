#!/usr/bin/env bash
#
# Script forked from praetorian-inc/epictreasure
# https://github.com/praetorian-inc/epictreasure
#

## create a user
sudo chown -R ubuntu:ubuntu /home/ubuntu && sudo chmod 4750 /home/ubuntu
sudo mkdir -p /home/ubuntu/tools && sudo mkdir -p /etc/sudoeres.d/
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoeres.d/ubuntu
echo "kernel.yama.ptrace_scope = 0" | sudo tee /etc/sysctl.d/10-ptrace.conf

## Updates
sudo apt-get -yq update
sudo apt-get -yq upgrade
sudo apt-get -yq install apt-utils python2.7 python-pip python2.7-dev python3-pip python3-dev python-dbg git \
    sudo p7zip autoconf libssl-dev libpcap-dev libffi-dev clang nasm tmux \
    gdb gdb-multiarch gdbserver foremost ipython stow build-essential virtualenvwrapper \
    ltrace strace socat tcpdump john hydra vim curl wget nmap \
    g++ gcc netcat netcat6 openssh-server openssh-client lsof

## Install 32 bit libs also
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -yq install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -yq install libc6-dev-i386

## QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -yq install qemu qemu-user qemu-user-static 'binfmt*' libc6-armhf-armel-cross debian-keyring debian-archive-keyring emdebian-archive-keyring
sudo tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF

sudo apt-get -yq install libc6-mipsel-cross libc6-arm-cross
sudo mkdir /etc/qemu-binfmt
sudo ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
sudo ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
sudo rm /etc/apt/sources.list.d/emdebian.list
sudo apt-get update

## Install Binjitsu
sudo pip2 install --upgrade git+https://github.com/binjitsu/binjitsu.git

## Install pwnlib-binutil
sudo apt-get install -yq software-properties-common
sudo apt-add-repository --yes ppa:pwntools/binutils
sudo apt-get update
ARCHES="aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sparc vax xscale i386 x86_64"
for arch in $ARCHES; do
    sudo apt-get -yq install binutils-$arch-linux-gnu
done

sudo mkdir /home/ubuntu/tools && \
sudo chown -R ubuntu.ubuntu /home/ubuntu/
sudo chown -R ubuntu.ubuntu /home/ubuntu/tools

## Install peda
cd /home/ubuntu/tools
git clone https://github.com/longld/peda.git
echo -en "define load_peda\n  source ~/tools/peda/peda.py\nend" >> ~/.gdbinit

## Install pwndbg
cd /home/ubuntu/tools
git clone https://github.com/zachriggle/pwndbg
echo -en "define load_pwndbg\n  source ~/tools/pwndbg/gdbinit.py\nend" >> ~/.gdbinit

## Install GDB Enhanced Features
cd /home/ubuntu/tools
git clone https://github.com/hugsy/gef.git
echo -en "define load_gef\n  source ~/tools/gef/gef.py\nend" >> ~/.gdbinit

## Capstone for pwndbg
cd /home/ubuntu/tools
git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

## pycparser for pwndbg
sudo pip3 install pycparser # Use pip3 for Python3

## Install radare2
cd /home/ubuntu/tools
git clone https://github.com/radare/radare2
cd radare2
sudo ./sys/install.sh

## Install binwalk
cd /home/ubuntu/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
sudo apt-get -yq install squashfs-tools

## Install Firmware-Mod-Kit
#apt-get -yq install zlib1g-dev liblzma-dev python-magic
#cd /home/ubuntu/tools
#wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
#tar xvf fmk_099.tar.gz
#rm fmk_099.tar.gz
#cd fmk_099/src
#./configure
#make

## Uninstall capstone
sudo pip2 uninstall capstone -y

## Install correct capstone
cd ~/tools/capstone/bindings/python
sudo python setup.py install

## Personal config not installed by default
cd /home/ubuntu
git clone https://github.com/boogy/dotfiles.git

## Install Angr framework
cd /home/ubuntu/tools
sudo pip2 install angr --upgrade

## Install american-fuzzy-lop
sudo apt-get -yq install clang llvm
cd /home/ubuntu/tools
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

## Install apktool - from https://github.com/zardus/ctf-tools
sudo apt-get update
sudo apt-get -yq install default-jre
cd /home/ubuntu/tools
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar
sudo mv apktool_2.0.2.jar /bin/apktool.jar
sudo mv apktool /bin/
sudo chmod 755 /bin/apktool
sudo chmod 755 /bin/apktool.jar

## Install preeny
# cd /home/ubuntu/tools
# git clone --depth 1 https://github.com/zardus/preeny
# PATH=$PWD/../crosstool/bin:$PATH
# cd preeny
# for i in ../../crosstool/bin/*-gcc
# do
#     t=$(basename $i)
#     CC=$t make -j $(nproc) -i
# done
# PLATFORM=-m32 setarch i686 make -i
# mv x86_64-linux-gnu i686-linux-gnu
# make -i

## Install Pillow
sudo apt-get build-dep python-imaging
sudo apt-get -yq install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
sudo pip2 install Pillow

## Install angr-dev
cd /home/ubuntu/tools
git clone https://github.com/angr/angr-dev
cd angr-dev
sudo ./setup.sh -i angr

## Replace ROPGadget with rp++
sudo apt-get -yq install cmake libboost-all-dev clang-3.5
export CC=/usr/bin/clang-3.5
export CXX=/usr/bin/clang++-3.5
cd /home/ubuntu/tools
git clone https://github.com/0vercl0k/rp.git
cd rp
git checkout next
git submodule update --init --recursive

# little hack to make it compile
sed -i 's/find_package(Boost 1.59.0 COMPONENTS flyweight)/find_package(Boost)/g' CMakeLists.txt
mkdir build && cd build && cmake ../ && make && sudo cp ../bin/rp-lin-x64 /usr/local/bin/

## Install ROPGadget
cd /home/ubuntu/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

## Install Z3 Prover
cd /home/ubuntu/tools
git clone https://github.com/Z3Prover/z3.git
cd z3
python scripts/mk_make.py
cd build
sudo make install
sudo python ../scripts/mk_make.py --python

## Install keystone engine
cd /home/ubuntu/tools
git clone https://github.com/keystone-engine/keystone.git
mkdir build
cd build
../make-share.sh
sudo make install
ldconfig
cd /home/ubuntu/tools/keystone/bindings/python
sudo make install

## Install qira
#cd /home/ubuntu/tools
#git clone https://github.com/BinaryAnalysisPlatform/qira.git
#cd qira/
#./install.sh

## Python pip cool modules
sudo pip2 install --upgrade r2pipe
sudo pip2 install --upgrade distorm3
sudo pip2 install --upgrade pycrypto
sudo pip2 install --upgrade git+https://github.com/hellman/xortool.git

# enable ssh on the box
sudo update-rc.d ssh defaults && service ssh start
