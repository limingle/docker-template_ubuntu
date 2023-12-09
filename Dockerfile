ARG BASE_IMG
FROM ${BASE_IMG} as base

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

ARG packages
ARG APT_MIRROR
RUN sed -ri \
        -e "s/(archive|security).ubuntu.com/${APT_MIRROR:-archive.ubuntu.com}/g" \
        /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        ${packages} \
    && rm -rf /var/lib/apt/lists/*

FROM base
MAINTAINER alexlee alexander.lee.cn@gmail.com
ARG userid
ARG groupid
ARG username

ENV HOME=/home/$username

RUN groupadd -g $groupid $username && \
    useradd -u $userid -g $groupid $username

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD ["echo -e \"USEAGE:\ndocker_<entry> [arg1 [arg2 [...] ] ]\""]
