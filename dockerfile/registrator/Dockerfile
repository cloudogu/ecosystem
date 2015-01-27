# cesi/registrator
# dockerfile is based on https://github.com/progrium/registrator
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV REGISTRATOR_VERSION 0.4.0

ADD https://github.com/progrium/registrator/releases/download/v${REGISTRATOR_VERSION}/registrator_${REGISTRATOR_VERSION}_linux_x86_64.tgz /tmp/registrator.tgz
RUN cd /bin && gzip -dc /tmp/registrator.tgz | tar -xf - && rm /tmp/registrator.tgz

ENV DOCKER_HOST unix:///var/run/docker.sock
ENTRYPOINT ["/bin/registrator"]
