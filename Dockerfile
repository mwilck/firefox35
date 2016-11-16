FROM sstrigler/squeeze
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	iceweasel \
        ca-certificates || /bin/true
ENTRYPOINT /usr/bin/iceweasel
