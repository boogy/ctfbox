#!/usr/bin/env bash
#
# Script forked from praetorian-inc/epictreasure
# https://github.com/praetorian-inc/epictreasure
#
## create a user
getent passwd ctf | useradd -m -s /bin/bash ctf
chown -R ctf: /home/ctf && chmod 4750 /home/ctf
mkdir -p /home/ctf/tools && mkdir -p /etc/sudoeres.d/
echo "ctf ALL=(ALL) NOPASSWD:ALL" > /etc/sudoeres.d/ctf
echo "kernel.yama.ptrace_scope = 0" > /etc/sysctl.d/10-ptrace.conf

## Updates
apt-get -y -q update
apt-get -y -q upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y -q install git sudo p7zip autoconf libssl-dev libpcap-dev \
        python2.7 python-pip python-dev python3-pip python3-dev libffi-dev clang nasm \
        tmux gdb gdb-multiarch foremost ipython stow build-essential virtualenvwrapper \
        ltrace strace socat tcpdump john hydra vim curl wget nmap python-dbg g++ gcc \
        netcat netcat6 openssh-server openssh-client lsof

## Install 32 bit libs also
dpkg --add-architecture i386
apt-get update
apt-get -yq install libc6:i386 libncurses5:i386 libstdc++6:i386
apt-get -yq install libc6-dev-i386

# Enable ssh by default in the container
# update-rc.d ssh defaults && service ssh start

## QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
apt-get -y -q install qemu qemu-user qemu-user-static 'binfmt*' libc6-armhf-armel-cross debian-keyring debian-archive-keyring emdebian-archive-keyring
tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF

apt-get -y -q install libc6-mipsel-cross libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list
apt-get update

## Install Binjitsu
pip install --upgrade git+https://github.com/binjitsu/binjitsu.git

## Install pwnlib-binutil
apt-get install --yes -q software-properties-common
apt-add-repository --yes ppa:pwntools/binutils
apt-get update
ARCHES="aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sparc vax xscale i386 x86_64"
for arch in $ARCHES; do
    apt-get install -yq binutils-$arch-linux-gnu
done

mkdir /home/ctf/tools && \
chown -R ctf: /home/ctf/tools

## Install peda
cd /home/ctf/tools
git clone https://github.com/longld/peda.git
echo -en "define load_peda\n  source ~/tools/peda/peda.py\nend" >> ~/.gdbinit

## Install pwndbg
cd /home/ctf/tools
git clone https://github.com/zachriggle/pwndbg
echo -en "define load_pwndbg\n  source ~/tools/pwndbg/gdbinit.py\nend" >> ~/.gdbinit

## Install GDB Enhanced Features
cd /home/ctf/tools
git clone https://github.com/hugsy/gef.git
echo -en "define load_gef\n  source ~/tools/gef/gef.py\nend" >> ~/.gdbinit

## Capstone for pwndbg
cd /home/ctf/tools
git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
./make.sh install
cd bindings/python
python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

## pycparser for pwndbg
pip3 install pycparser # Use pip3 for Python3

## Install radare2
cd /home/ctf/tools
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

## Install binwalk
cd /home/ctf/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
python setup.py install
apt-get install -yq squashfs-tools

## Install Firmware-Mod-Kit
#apt-get -y -q install zlib1g-dev liblzma-dev python-magic
#cd /home/ctf/tools
#wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
#tar xvf fmk_099.tar.gz
#rm fmk_099.tar.gz
#cd fmk_099/src
#./configure
#make

## Uninstall capstone
pip2 uninstall capstone -y

## Install correct capstone
cd ~/tools/capstone/bindings/python
python setup.py install

## Personal config not installed by default
cd /home/ctf
git clone https://github.com/boogy/dotfiles.git

## Install Angr framework
cd /home/ctf/tools
pip install angr --upgrade

## Install american-fuzzy-lop
apt-get -yq install clang llvm
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
  make install
)

## Install apktool - from https://github.com/zardus/ctf-tools
apt-get update
apt-get install -yq default-jre
cd /home/ctf/tools
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar
mv apktool_2.0.2.jar /bin/apktool.jar
mv apktool /bin/
chmod 755 /bin/apktool
chmod 755 /bin/apktool.jar

## Install preeny
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

## Install Pillow
apt-get build-dep python-imaging
apt-get install -yq libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
pip install Pillow

## Install angr-dev
cd /home/ctf/tools
git clone https://github.com/angr/angr-dev
cd angr-dev
./setup.sh -i angr

## Replace ROPGadget with rp++

apt-get install -yq cmake libboost-all-dev clang-3.5
export CC=/usr/bin/clang-3.5
export CXX=/usr/bin/clang++-3.5
cd /home/ctf/tools
git clone https://github.com/0vercl0k/rp.git
cd rp
git checkout next
git submodule update --init --recursive

# little hack to make it compile
sed -i 's/find_package(Boost 1.59.0 COMPONENTS flyweight)/find_package(Boost)/g' CMakeLists.txt
mkdir build && cd build && cmake ../ && make && cp ../bin/rp-lin-x64 /usr/local/bin/


## Install ROPGadget
cd /home/ctf/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
python setup.py install

## Install Z3 Prover
cd /home/ctf/tools
git clone https://github.com/Z3Prover/z3.git
cd z3
python scripts/mk_make.py
cd build
make install
python ../scripts/mk_make.py --python

## Install qira
#cd /home/ctf/tools
#git clone https://github.com/BinaryAnalysisPlatform/qira.git
#cd qira/
#./install.sh

## Python pip cool modules
pip install --upgrade r2pipe
pip install --upgrade distorm3
pip install --upgrade pycrypto
pip install --upgrade git+https://github.com/hellman/xortool.git
