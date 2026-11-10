FROM debian:13.7-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server python3 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd /root/.ssh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
