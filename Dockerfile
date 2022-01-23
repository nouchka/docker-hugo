FROM debian:stable-slim

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=gohugoio/hugo
ARG VERSION=0.92.0
ARG FILE_SHA256SUM=5305401d4618a18d06ea5e21913c4be55b279a8dacc69e3add36a9bb9b11cb4d
ENV FILE_URL https://github.com/${REPOSITORY}/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz

WORKDIR /tmp
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* tar=* ca-certificates=* make=* && \
	wget -qO- "${FILE_URL}" > /tmp/archive.tgz && \
	sha256sum /tmp/archive.tgz && \
	echo "${FILE_SHA256SUM}  /tmp/archive.tgz"| sha256sum -c - && \
	tar xzf - -C / < /tmp/archive.tgz && \
	cp /hugo /usr/sbin/hugo && \
	chmod +x /usr/sbin/hugo && \
	chmod +x /hugo && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	export uid=${PUID} gid=${PGID} && \
	mkdir -p /home/developer/hugo && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	chown "${uid}:${gid}" -R /home/developer

VOLUME /home/developer/hugo
WORKDIR /home/developer/hugo

USER developer
ENTRYPOINT [ "/hugo" ]
