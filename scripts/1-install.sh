#! /usr/bin/bash

disk="/dev/$1"

echo "---------------Installing base----------------"
pacstrap /mnt --noconfirm base linux linux-firmware --noconfirm
genfstab -L /mnt >> /mnt/etc/fstab

echo "---------------Installing grub----------------"
pacstrap /mnt --noconfirm grub efibootmgr sed

arch-chroot /mnt /bin/bash <<"EOS"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
sed -i 's/loglevel=3 quiet//' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
EOS

echo "Done installing base system"