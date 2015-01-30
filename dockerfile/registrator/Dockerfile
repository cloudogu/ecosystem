# cesi/registrator
# dockerfile is based on https://github.com/progrium/registrator
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ADD registrator_0.4.0_patched.tgz /bin
RUN chmod +x /bin/registrator

ENV DOCKER_HOST unix:///var/run/docker.sock
ENTRYPOINT ["/bin/registrator"]
