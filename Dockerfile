FROM docker.io/alpine:3.8

MAINTAINER Kimsufi User <no@name.com>

RUN apk update && \
    apk add bash openssh rsync augeas && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    mkdir -p /etc/authorized_keys && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile "/etc/authorized_keys/%u"' && \
    augtool 'set /files/etc/ssh/sshd_config/PermitRootLogin "no"' && \
    augtool 'set /files/etc/ssh/sshd_config/ChallengeResponseAuthentication "no"' && \
    augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication "no"' && \
    augtool 'set /files/etc/ssh/sshd_config/AllowTcpForwarding "no"' && \
    augtool 'set /files/etc/ssh/sshd_config/X11Forwarding "no"' && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
