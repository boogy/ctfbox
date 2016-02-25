CTFBOX
=======

When playing CTFs I like to have all the tools ready to rock when needed.
This docker image will provide these tools installed on ubuntu:latest image.

It's also possible to build this box using [Vagrant](https://www.vagrantup.com/).
The script was inspired by [praetorian-inc/epictreasure](https://github.com/praetorian-inc/epictreasure)

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

