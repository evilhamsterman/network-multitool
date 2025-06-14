# hadolint global ignore=DL3018
ARG ALPINE_VERSION=3

FROM alpine:3

###
# set a password to SSH into the docker container with
ENV USER=dan
RUN adduser -D -s /bin/bash "${USER}" && \
    adduser ${USER} wheel && \
    echo "${USER}:${USER}" | chpasswd
COPY wheel-nopasswd /etc/sudoers.d/
###

COPY dotfiles/ /home/${USER}
RUN chown -R ${USER}:${USER} "/home/${USER}"

COPY entrypoint.fish /

# Install some tools in the container
# Packages are listed in alphabetical order
RUN apk add --no-cache \
    bind-tools \
    busybox-extras \
    curl \
    envsubst \
    ethtool \
    fish \
    flux \
    git \
    inetutils-telnet \
    iperf3 \
    iproute2 \
    helix \
    helm \
    jq \
    k9s \
    kubectl \
    mtr \
    net-tools \
    netcat-openbsd \
    nmap \
    openssh \
    openssl \
    rsync \
    starship \
    socat \
    sudo \
    tailscale \
    task \
    tini \
    tcpdump \
    tcptraceroute \
    tshark \
    wget

EXPOSE 22

USER ${USER}

# The entrypoint script will either run a command passed or just sleep for infinity
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.fish"]
