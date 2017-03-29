# registry.cloudogu.com/official/registrator:0.6.0
# dockerfile is based on https://github.com/progrium/registrator
FROM registry.cloudogu.com/official/base:3.5-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

ADD startup.sh /startup.sh
ADD registrator_0.6.0_patched.tgz /bin
RUN chmod +x /bin/registrator /startup.sh

ENV DOCKER_HOST unix:///var/run/docker.sock
CMD ["/startup.sh"]
