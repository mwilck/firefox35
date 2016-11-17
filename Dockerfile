FROM sstrigler/squeeze
# apt-get install fails to configure dbus in the container
# installing icedtea plugin  causes broken dependencies if
# update repo is active and updated tzdata is installed
RUN sed -i '/updates/s/^/#/' /etc/apt/sources.list && \
   apt-get update && \
   apt-get install -y --force-yes --no-install-recommends \
   	   tzdata=2014e-0squeeze1 \
	   icedtea6-plugin \
	   iceweasel \
	   ca-certificates || /bin/true

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
