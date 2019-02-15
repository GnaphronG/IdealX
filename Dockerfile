#FROM nvidia/cuda:10.0-runtime-ubuntu18.04 as release
FROM ubuntu:18.04

ARG STEAM_USER=steam
ARG STEAM_ID=1000
ARG DEBIAN_FRONTEND=noninteractive
ARG STEAM_DIR=/home/steam/.local/share/Steam

ADD http://media.steampowered.com/client/installer/steam.deb /tmp/steam.deb

RUN dpkg -i /tmp/*.deb \
    || dpkg --add-architecture i386 \
    && apt update \
    && apt install -f -y \
    && apt install -yqq pciutils sudo 

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
    && groupadd wheel \
    && useradd -ms /bin/bash -u 1000 -U -G wheel ${STEAM_USER} \
    && mkdir -p ${STEAM_DIR} \
    && chown ${STEAM_USER}:${STEAM_USER} ${STEAM_DIR} 

USER ${STEAM_USER}
WORKDIR /home/${STEAM_USER}
VOLUME ${STEAM_DIR}
CMD ["steam"]

