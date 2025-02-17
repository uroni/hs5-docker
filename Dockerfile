FROM ubuntu:22.04

ARG VERSION=0.1.4
ARG TARGETPLATFORM
ARG UID=1000
ARG GID=1000

RUN URL=https://github.com/uroni/hs5/releases/download/${VERSION} && \
    case ${TARGETPLATFORM} in \
         "linux/amd64")  URL=$URL/hs5.xz  ;; \
         "linux/arm64")  URL=$URL/hs5-todo.xz  ;; \
         "linux/arm/v7") URL=$URL/hs5-todo.xz  ;; \
         "linux/386" | "linux/i386")   URL=$URL/hs5-todo.xz   ;; \
    esac \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y wget xz-utils \
    && wget -q "$URL" -O /usr/bin/hs5.xz \
    && xz -d /usr/bin/hs5.xz \
    && apt-get remove -y wget xz-utils \
    && apt-get autoremove -y \
    && chmod +x /usr/bin/hs5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $GID hs5 \
    && useradd -m hs5 -u $UID -g $GID \
    && mkdir /data && mkdir /metadata \
    && chown hs5:hs5 /data \
    && chown hs5:hs5 /metadata

USER hs5

WORKDIR /home/hs5

EXPOSE 80

ENV DATA_PATH="/data"
ENV METADATA_PATH="/metadata"

VOLUME [ "/data", "/metadata"]
ENTRYPOINT ["/usr/bin/hs5"]
CMD ["run"]