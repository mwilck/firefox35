FROM debian:squeeze

# debian:squeeze has outdated sources.list
# Squeeze is only available from archive.debian.org
COPY sources.list /etc/apt/sources.list

# Installing icedtea plugin causes broken dependencies if
# id updated tzdata is installed
RUN \
   apt-get update && \
   apt-get install -y --force-yes --no-install-recommends \
   	   tzdata=2014e-0squeeze1 \
	   icedtea6-plugin \
	   iceweasel \
	   ca-certificates && \
   apt-get clean

# For some reason useradd -m fails to create the home dir
# causing docker build to fail
# this happens only with the squeeze image
RUN mkdir -p /home/surfer && \
 useradd -u 1000 -g users surfer && \
 cp -a /etc/skel/.[a-z]* /home/surfer && \
 chown -R surfer.users /home/surfer

USER surfer
ENV HOME /home/surfer
WORKDIR /home/surfer
ENTRYPOINT /usr/bin/iceweasel
