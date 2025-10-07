FROM alpine:3.22

ENV PROOT_VERSION=5.4.0

ENV LANG=en_US.UTF-8

RUN apk update && \
    apk add --no-cache \
        bash \
        jq \
        curl \
        ca-certificates \
        iproute2 \
        xz \
        shadow

RUN ARCH=$(uname -m) && \
    mkdir -p /usr/local/bin && \
    proot_url="https://github.com/ysdragon/proot-static/releases/download/v${PROOT_VERSION}/proot-${ARCH}-static" && \
    curl -Ls "$proot_url" -o /usr/local/bin/proot && \
    chmod 755 /usr/local/bin/proot

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

RUN adduser -D -h /home/container -s /bin/sh container

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

ENTRYPOINT ["./entrypoint.sh"]