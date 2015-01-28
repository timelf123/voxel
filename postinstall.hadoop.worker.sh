#!/bin/bash -eu
# Copyright 2015 mbr targeting GmbH. All Rights Reserved.

#######################################
# Creates data file systems for hadoop worker nodes
#######################################

FSTAB_OPTIONS="noatime,data=writeback,barrier=0,nobh,errors=remount-ro"

declare -a PARTITIONS=(
  '/dev/sdb /data/2
   /dev/sdc /data/3
   /dev/sdd /data/4
   /dev/sde /data/5
   /dev/sdf /data/6
   /dev/sdg /data/7
   /dev/sdh /data/8'
)

#######################################
# Exchanging /dev/sda4's filesystem,
# because we are not able to set all mount and filesystem options using
# partman.
# Globals:
#   FSTAB_OPTIONS
# Arguments:
#   None
# Returns:
#   None
#######################################
function changeDevSda4 {
    sed -i '/.*\/data\/1/d' /etc/fstab
    mkfs.ext4 -T largefile4 -m0 /dev/sda4
    echo "/dev/sda4 /data/1 ext4 ${FSTAB_OPTIONS} 0 0" >> /etc/fstab
}

#######################################
# Expects device/locations tuples from STDIN. Creates new gpt partition table
# and one ext4 formated partition on each device. Also adds a mount line to
# fstab.
# Globals:
#   FSTAB_OPTIONS
# Arguments:
#   None
# Returns:
#   None
#######################################
function createSingleDataPartition {
    while read DEVICE LOCATION ; do
        parted -s ${DEVICE} mktable gpt
        parted -s ${DEVICE} -- mkpart ${LOCATION} ext2 1MiB 100%
        mkfs.ext4 -T largefile4 -m0 ${DEVICE}1
        mkdir -p ${LOCATION}
        echo "${DEVICE}1 ${LOCATION} ext4 ${FSTAB_OPTIONS} 0 0" >> /etc/fstab
    done
}

changeDevSda4
echo "${PARTITIONS[@]}" | createSingleDataPartition
