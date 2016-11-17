FROM sstrigler/squeeze
# apt-get install fails to configure dbus in the container
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
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
