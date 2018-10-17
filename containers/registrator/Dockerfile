# registry.cloudogu.com/official/registrator:0.7.0
# dockerfile is based on https://github.com/progrium/registrator
FROM registry.cloudogu.com/official/base:3.7-4
LABEL maintainer="sebastian.sdorra@cloudogu.com" \
      NAME="official/registrator" \
      VERSION="0.7.0-1"

ADD startup.sh /startup.sh
ADD registrator_0.7.0_patched.tgz /bin
RUN chmod +x /bin/registrator /startup.sh

ENV DOCKER_HOST unix:///var/run/docker.sock
CMD ["/startup.sh"]
