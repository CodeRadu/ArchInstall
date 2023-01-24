#! /usr/bin/bash

disk="/dev/$1"

# Install keyring
echo "---------Installing required packages---------"
pacman -Sy --noconfirm archlinux-keyring gptfdisk glibc

# Format disk
echo "--------------Partitioning disk---------------"
umount -A --recursive /mnt

# Zap the disk
sgdisk -Z $disk # Clear the disk
sgdisk -o $disk # Make gpt structure

# Create the partitions
sgdisk -n 1::+300M --typecode=1:ef00 --change-name=1:'EFI boot' $disk # partition 1 EFI boot
sgdisk -n 2::-1024M --typecode=2:8300 --change-name=2:'Root' $disk # partition 2 rootfs
sgdisk -n 3::-0 --typecode=3:8200 --change-name=3:'Swap' $disk # partition 3 swap

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
mkfs -t fat -F 32 $boot
mkfs -t ext4 $root
mkswap $swap

echo "----------------Mounting disk-----------------"
mount $root /mnt
mkdir /mnt/boot
mount $boot /mnt/boot
swapon $swap

echo "Setup script done!"