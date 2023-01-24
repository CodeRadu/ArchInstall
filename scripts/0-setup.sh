#! /usr/bin/bash

disk="/dev/$1"

# Install keyring
echo "---------Installing required packages---------"
pacman -Sy --noconfirm glibc archlinux-keyring
pacman -S --noconfirm --needed gptfdisk

# Format disk
echo "--------------Partitioning disk---------------"
umount -A --recursive /mnt

# Zap the disk
sgdisk -Z $disk || exit 1 # Clear the disk
sgdisk -o $disk || exit 1 # Make gpt structure

# Create the partitions
sgdisk -n 1::+300M --typecode=1:ef00 --change-name=1:'EFI boot' $disk || exit 1 # partition 1 EFI boot
sgdisk -n 2::-1024M --typecode=2:8300 --change-name=2:'Root' $disk || exit 1 # partition 2 rootfs
sgdisk -n 3::-0 --typecode=3:8200 --change-name=3:'Swap' $disk || exit 1 # partition 3 swap

if [[ "${disk}" =~ "nvme" ]]; then
  boot="${disk}p1"
  root="${disk}p2"
  swap="${disk}p3"
else
  boot="${disk}1"
  root="${disk}2"
  swap="${disk}3"
fi

echo "---------------Formatting disk----------------"
mkfs -t fat -F 32 $boot || exit 1
mkfs -t ext4 $root || exit 1
mkswap $swap || exit 1

echo "----------------Mounting disk-----------------"
mount $root /mnt || exit 1
mkdir /mnt/boot || exit 1
mount $boot /mnt/boot || exit 1
swapon $swap || exit 1

echo "Setup script done!"