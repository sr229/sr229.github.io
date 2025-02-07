ARG KERNEL_TAG=1.20230405
ARG ALPINE_VERSION=3.21.2

FROM ubuntu:24.04 AS rootfs-dev
RUN apt-get update && apt-get install -y gcc-aarch64-linux-gnu linux-libc-dev-arm64-cross git make wget
RUN mkdir -p /tmp/rootfs
WORKDIR /tmp/rootfs
RUN wget https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/aarch64/alpine-minirootfs-${ALPINE_VERSION}-aarch64.tar.gz -O alpine-rootfs.tgz
RUN tar -xvzf alpine-rootfs.tgz && rm -rfv alpine-rootfs.tgz
COPY --chown=root:root etc /etc
COPY --chown=root:root root /root
WORKDIR /tmp
RUN dd if=/dev/zero of=rootfs.bin bs=12M count=1
RUN mke2fs -d /tmp/rootfs rootfs.bin
RUN mkdir /tmp/out/ && mv rootfs.bin /tmp/out/


FROM ubuntu:24.04 AS kernel-dev
ARG KERNEL_TAG
WORKDIR /work
RUN apt-get update && apt-get install -y crossbuild-essential-arm64 git gperf bc bison flex libssl-dev make libc6-dev libncurses5-dev wget
RUN wget https://github.com/raspberrypi/linux/archive/refs/tags/${KERNEL_TAG}.tar.gz
RUN tar -xzvf ${KERNEL_TAG}.tar.gz
WORKDIR /work/linux-${KERNEL_TAG}
RUN ls
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc) Image dtbs
RUN mkdir /out
RUN cp arch/arm64/boot/Image /out/kernel8.img
RUN cp arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b-plus.dtb /out/

FROM scratch
COPY --from=rootfs-dev /tmp/out/rootfs.bin /
COPY --from=kernel-dev /out/ /