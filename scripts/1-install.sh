#! /usr/bin/bash

disk="/dev/$1"

echo "---------------Installing base----------------"
pacstrap /mnt base linux linux-firmware nano sudo gurb efibootmgr --noconfirm
genfstab -L /mnt >> /mnt/etc/fstab

arch-chroot /mnt

echo "---------------Installing grub----------------"
grub-install --target=x86_64-efi --efi-directory=/mnt/boot --bootloader-id=grub
sed 's/quiet splash//' /mnt/etc/default/grub
sed 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /mnt/etc/default/grub
sed 's/menu/hidden/' /mnt/etc/default/grub