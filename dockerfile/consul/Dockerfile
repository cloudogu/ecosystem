# cesi/consul
# dockerfile is based on https://github.com/progrium/docker-consul
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV CONSUL_VERSION 0.4.1

RUN apt-get update
RUN apt-get install -yy unzip

RUN /bin/bash -c "mkdir -p /consul/{bin,data,ui}"

ADD https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN cd /consul/bin && unzip /tmp/consul.zip && chmod +x consul && rm /tmp/consul.zip

ADD https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip /tmp/webui.zip
RUN cd /consul/ui && unzip /tmp/webui.zip && rm /tmp/webui.zip

ADD ./config /consul/config/

RUN useradd -d /consul -M -s /bin/bash -p '*' consul
RUN chown -R consul:consul /consul

# cleanup
RUN apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose ports and data
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/consul/data"]

USER consul
ENV SHELL /bin/bash

# TODO check http://www.consul.io/docs/agent/options.html#_bootstrap_expect
CMD ["/consul/bin/consul", "agent", "-config-dir=/consul/config", "-server", "-bootstrap"]
