FROM debian:stable-slim
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-hugo"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=gohugoio/hugo
ARG VERSION=0.49
ARG FILE_SHA256SUM=768296178bb3ca5daaf39d897a2505f91e0224ca48a41dc0d1d73120859c4b1f
ENV TAG_STRIP v
ENV FILE_URL https://github.com/${REPOSITORY}/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz

WORKDIR /tmp
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* tar=* ca-certificates=* && \
	wget -qO- "${FILE_URL}" > /tmp/archive.tgz && \
	sha256sum /tmp/archive.tgz && \
	echo "${FILE_SHA256SUM}  /tmp/archive.tgz"| sha256sum -c - && \
	tar xzf - -C / < /tmp/archive.tgz && \
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
