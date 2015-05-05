# cesi/bugzilla
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# download bugzilla
RUN wget https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-4.4.9.tar.gz

# extract bugzilla and install apt dependecies
RUN apt-get update -y \
    && apt-get -y install build-essential mysql-client perl cpanminus libdatetime-perl libgd-gd2-perl libdbd-mysql-perl libxml-perl \
		&& tar xvfz bugzilla-4.4.9.tar.gz \
		&& rm -f bugzilla-4.4.9.tar.gz \
		&& mv bugzilla-* /bugzilla
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup bugzilla
RUN cd /bugzilla \
    && perl /bugzilla/install-module.pl --all

# add startup
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD "/startup.sh"
