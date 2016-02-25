CTFBOX
=======

When playing CTFs I like to have all the tools ready to rock when needed.
This docker image will provide these tools installed on ubuntu:latest image.

It's also possible to build this box using [Vagrant](https://www.vagrantup.com/).
The script(s) war forked from [praetorian-inc/epictreasure](https://github.com/praetorian-inc/epictreasure)

Installation
=============

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
docker run -it ctfbox
```

List of some tools installed and examples
=============================================

binjitsu
------------

```python
from pwn import *
context(arch = 'i386', os = 'linux')

r = remote('exploitme.example.com', 31337)
# EXPLOIT CODE GOES HERE
r.send(asm(shellcraft.sh()))
r.interactive()
```

Peda
------

## Screenshot
![start](http://i.imgur.com/P1BF5mp.png)

![pattern arg](http://i.imgur.com/W97OWRC.png)


Pwndbg
---------

## Screenshots

Here's a screenshot of `pwndbg` working on an aarch64 binary running under `qemu-user`.

![aarch64](https://raw.githubusercontent.com/zachriggle/pwndbg/master/caps/a.png)

