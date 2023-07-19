FROM ubuntu:latest

# non interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# build args
ARG BRAND
ARG TAG

# install packages needed by fahclient installer
RUN apt-get update \
    && apt-get install --no-install-recommends -y bzip2 tzdata

# add files to image
COPY docker-entrypoint.sh /
COPY add/config.xml /etc/fahclient/
ADD https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/${BRAND}/fahclient_${TAG}_amd64.deb /fahclient.deb

# do not properly install package, but only retrieve binaries
RUN dpkg -x ./fahclient.deb ./deb &&\
 mv deb/usr/bin/* /usr/bin &&\
 rm -rf *.deb &&\
 rm -rf deb &&\
 chmod u+x /docker-entrypoint.sh &&\
 rm -rf /var/lib/apt/lists/*

# Timezone var
ENV TZ=${TZ}

# go to homedir
WORKDIR /var/lib/fahclient

# entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
