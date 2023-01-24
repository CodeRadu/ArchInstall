#! /usr/bin/bash

function quit() {
  reason=$1
  echo "Installation failed in '$reason' script"
  exit 1
}

echo -ne "
----------Radu's arch install script----------
This script automatically installs arch linux to your computer
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
echo "Running setup script"
bash scripts/0-setup.sh $diskname || quit "setup"
echo "Running install script"
bash scripts/1-install.sh || quit "install"
echo "Running user script"
bash scripts/2-user.sh || quit "user"
echo "Running desktop script"
bash scripts/3-desktop.sh || quit "desktop"

echo "Unmounting disk"
umount /mnt/boot
umount /mnt
swapoff /dev/${diskname}3

reboot now