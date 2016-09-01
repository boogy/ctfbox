CTFBOX
=======

[![](https://images.microbadger.com/badges/image/boogy/ctfbox.svg)](http://microbadger.com/images/boogy/ctfbox "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/boogy/ctfbox.svg)](http://microbadger.com/images/boogy/ctfbox "Get your own version badge on microbadger.com")

When playing CTFs I like to have all the tools ready to rock when needed.
This docker image will provide these tools installed on ubuntu:latest image.

The script(s) was forked from [praetorian-inc/epictreasure](https://github.com/praetorian-inc/epictreasure)

Similar configurations [ctf-tools](https://github.com/zardus/ctf-tools)

Installation/ Build
=====================

```bash
git clone https://github.com/boogy/ctfbox.git
cd ctfbox
docker build -t ctfbox .
```

Docker Hub
==========

The image is also present on [docker hub](https://hub.docker.com/r/boogy/ctfbox/)

```bash
docker pull boogy/ctfbox
```


Run the ctfbox
================

Start the image

```bash
docker run -it boogy/ctfbox
```

If you have problems with gdb or gdbserver you can run the container in privileged mode and with the host network.

```bash
sudo docker run -it --privileged --net=host boogy/ctfbox
```

List of some tools installed and examples
=============================================

  * [Z3 Solver](https://github.com/Z3Prover/z3)
  * [Capstone](https://github.com/aquynh/capstone)
  * [Keystone Engine](https://github.com/keystone-engine/keystone)
  * [Binwalk](http://binwalk.org/)
  * [radare2](https://github.com/radare/radare2)
  * [Afl](http://lcamtuf.coredump.cx/afl/)
  * [Angr](https://github.com/angr/angr)
  * [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)
  * [rp++](https://github.com/0vercl0k/rp)
  * [binjitsu](https://github.com/binjitsu/binjitsu)
  * [peda](https://github.com/longld/peda)
  * [pwndbg](https://github.com/zachriggle/pwndbg)


Screenshots
------------

binjitsu - CTF toolkit
------------------------
```python
from pwn import *
context(arch = 'i386', os = 'linux')

r = remote('exploitme.example.com', 31337)
# EXPLOIT CODE GOES HERE
r.send(asm(shellcraft.sh()))
r.interactive()
```

Radare2
---------
![radare2](http://radare.org/r/img/r2cg.png)
![radare2 webui](http://radare.org/r/img/webui.png)

Peda
------
![start](http://i.imgur.com/P1BF5mp.png)


ROPGadget
-----------
![x64-ropgadget](http://shell-storm.org/project/ROPgadget/x64.png)


