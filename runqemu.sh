#!/bin/bash
#Script to run QEMU for buildroot as the default configuration qemu_aarch64_virt_defconfig
#Host forwarding: Host Port 10022 ->> QEMU Port 22 
#Author: Siddhant Jajoo.

#SCRIPT_PATH=$(cd $(dirname $0) && pwd)

SCRIPT_PATH=$(realpath -e $(dirname $BASH_SOURCE))
if [ -d ${SCRIPT_PATH}/images ]
then
IMAGE_PATH="${SCRIPT_PATH}/images"
else
IMAGE_PATH="buildroot/output/images"
fi

qemu-system-aarch64 \
    -M virt  \
    -cpu cortex-a53 -nographic -smp 1 \
    -kernel ${IMAGE_PATH}/Image \
    -append "rootwait root=/dev/vda console=ttyAMA0" \
    -netdev user,id=eth0,hostfwd=tcp::10022-:22,hostfwd=tcp::9000-:9000,hostfwd=tcp::10000-:10000 \
    -device virtio-net-device,netdev=eth0 \
    -drive file=${IMAGE_PATH}/rootfs.ext4,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 -device virtio-rng-pci
