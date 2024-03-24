FROM --platform=linux/amd64 registry.fedoraproject.org/fedora-minimal:38-x86_64

LABEL org.opencontainers.image.source https://github.com/OliveTin/OliveTin
LABEL org.opencontainers.image.title=OliveTin

EXPOSE 1337/tcp

RUN mkdir -p /config /config/entities/ /var/www/olivetin \
    && \
	microdnf install -y --nodocs --noplugins --setopt=keepcache=0 --setopt=install_weak_deps=0 \
		iputils \
		openssh-clients \
		shadow-utils \
		apprise \
		docker \
	&& microdnf clean all

RUN useradd --system --create-home --home-dir /config/homedir olivetin -u 1000
COPY config.yaml /config
COPY var/entities/* /config/entities/

VOLUME /config

COPY OliveTin /usr/bin/OliveTin
COPY webui /var/www/olivetin/

USER olivetin

ENTRYPOINT [ "/usr/bin/OliveTin" ]
