FROM ubuntu:latest
MAINTAINER boogy <theboogymaster@gmail.com>

RUN useradd -m -s /bin/bash ctf && \
    mkdir -p /home/ctf/tools && \
    mkdir -p /etc/sudoers.d/ && \
    echo "ctf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ctf

COPY setup.sh /home/ctf/setup.sh

RUN cd /home/ctf/ && \
    chmod +x /home/ctf/setup.sh && \
    bash /home/ctf/setup.sh && \
    chown -R ctf: /home/ctf/tools

# qira ports
EXPOSE 3002 3003 4000

CMD ["/bin/bash", "-i"]
