FROM debian:squeeze

# debian:squeeze has outdated sources.list
# Squeeze is only available from archive.debian.org
COPY sources.list /etc/apt/sources.list

# Installing icedtea plugin causes broken dependencies if
# id updated tzdata is installed
RUN \
   apt-get update -o Acquire::Check-Valid-Until=false && \
   apt-get install -y --no-install-recommends \
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
