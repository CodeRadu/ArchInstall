#! /usr/bin/bash

echo "---------------Installing base----------------"
pacstrap /mnt --noconfirm base linux linux-firmware networkmanager
genfstab -L /mnt >> /mnt/etc/fstab

# Enable networkmanager
arch-chroot /mnt /bin/bash << EOS
systemctl enable NetworkManager
EOS

echo "-----------Installing systemd-boot------------"
arch-chroot /mnt /bin/bash << EOS
bootctl install
EOS
cat > /mnt/boot/loader/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root="LABEL=arch-root" rw
EOF
cat > /mnt/boot/loader/loader.conf << EOF
default arch.conf
timeout 0
editor no
EOF

echo "Done installing base system!"