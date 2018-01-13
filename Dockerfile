FROM debian:stable-slim
LABEL maintainer="Jean-Avit Promis docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-hugo"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=gohugoio/hugo
ARG VERSION=0.32.4
ARG FILE_SHA256SUM=004e437e4afa7a3556019b4215767d6823435d9a4c5b6f82715b93ac93bea44f
ENV TAG_STRIP v
ENV FILE_URL https://github.com/${REPOSITORY}/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz

WORKDIR /tmp
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget tar ca-certificates && \
	wget -qO- "${FILE_URL}" > /tmp/archive.tgz && \
	sha256sum /tmp/archive.tgz && \
	echo "${FILE_SHA256SUM}  /tmp/archive.tgz"| sha256sum -c - && \
	cat /tmp/archive.tgz| tar xzf - -C / && \
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
