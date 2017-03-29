FROM registry.cloudogu.com/official/java:8u121-2
MAINTAINER	stephan christann	<stephan.christann@christann.net>

# ADD USER JENKINS AND UNLOCK WITH RANDOM PASSWORD
RUN addgroup -S -g 1000 jenkins && \
    adduser -S -h /home/jenkins -s /bin/bash -G jenkins -u 1000 jenkins && \
    echo jenkins:$(openssl rand -base64 32) | chpasswd

# INSTALL SSHD
RUN apk add --update openssh openssh-client \
	&& echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
	&& echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
	&& echo "Protocol 2" >> /etc/ssh/sshd_config \
	&& echo "AllowUsers jenkins" >> /etc/ssh/sshd_config \
	&& echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config \
	&& echo "RSAAuthentication yes" >> /etc/ssh/sshd_config \
	&& echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
	&& rm -rf /var/cache/apk/*

# Add STARTUP
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME  ["/tmp", "/etc/ces/", "/home/jenkins"]

# SSH PORT
EXPOSE 22/tcp

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
