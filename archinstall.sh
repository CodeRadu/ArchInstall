#! /usr/bin/bash

function quit() {
  reason=$1
  echo "Installation failed in '$reason' script"
  exit 1
}

echo -ne "
----------Radu's arch install script----------
This script automatically installs arch linux on your computer
----------------------------------------------
WARNING: If you're not using UEFI, your system will not boot!
"
lsblk -d
echo "Choose disk (sda, sdb..)"
read diskname
if [ ! -b "/dev/$diskname" ]; then
  echo "Not a block device"
  exit 1
fi

function normal() {
  echo "Running setup script"
  bash scripts/0-setup.sh $diskname || quit "setup"
  echo "Running install script"
  bash scripts/1-install.sh || quit "install"
  echo "Running user script"
  bash scripts/2-user.sh || quit "user"
  echo "Running desktop script"
  bash scripts/3-desktop.sh || quit "desktop"
}

function nogit() {
  DOWNLOAD_URL="https://raw.githubusercontent.com/CodeRadu/ArchInstall/dev/"
  echo "Running without git (using curl)"
  echo "Running setup script"
  curl "$DOWNLOAD_URL/scripts/0-setup.sh" | bash -s $diskname || quit "setup"
  echo "Running install script"
  curl "$DOWNLOAD_URL/scripts/1-install.sh" | bash -s $diskname || quit "install"
  echo "Running user script"
  curl "$DOWNLOAD_URL/scripts/2-user.sh" | bash -s $diskname || quit "user"
  echo "Running desktop script"
  curl "$DOWNLOAD_URL/scripts/3-desktop.sh" | bash -s $diskname || quit "desktop"
}

if [ "$1" == "nogit" ]; then
  nogit
else
  normal
fi

echo "Unmounting disk"
umount /mnt/boot
umount /mnt
swapoff /dev/${diskname}3

reboot now