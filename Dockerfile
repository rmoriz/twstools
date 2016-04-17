FROM alpine:3.3

RUN apk add --update autoconf automake libtool g++ make help2man gengetopt gcc libxml2-dev git && rm -rf /var/cache/apk/*

RUN cd /tmp \
    && git clone https://github.com/rudimeier/twsapi \
    && cd twsapi \
    && autoreconf -vfi \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/twsapi

ADD . /tmp/twstools

WORKDIR /tmp/twstools

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN autoreconf -vfi \
    && ./configure \
    && make install

WORKDIR /tmp/work

# docker build -t twstools .
# docker run -i -t twstools twsdo -h 10.0.2.21 -A

# to redirect XML to a file on the host, obmit the "-t" option!
# see https://github.com/docker-exec/dexec/issues/42
#
# docker run -v $PWD:/tmp/data twstools twsdo -h 10.0.2.21 /tmp/data/options.xml 1>output.xml
#
