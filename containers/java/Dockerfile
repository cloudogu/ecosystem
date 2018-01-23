FROM registry.cloudogu.com/official/base:3.7-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# build arguments, passed from Makefile
ARG JAVA_ALPINE_VERSION

# environment variables
ENV \
  # default to utf-8 encoding
  LANG="C.UTF-8" \
  # java home
  JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
  # add java binaries to path
  PATH="$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin"

RUN set -x \
 # install java JAVA_ALPINE_VERSION is define in Makefile
 && apk add --no-cache openjdk8="${JAVA_ALPINE_VERSION}"

# copy resources
COPY resources/ /
