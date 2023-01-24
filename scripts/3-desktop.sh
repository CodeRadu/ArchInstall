#! /usr/bin/bash

echo "----------------Installing DE-----------------"
arch-chroot /mnt /bin/bash << EOS
pacman -S --noconfirm kde-standard
pacman -R --noconfirm konqueror
pacman -S --noconfirm chromium

systemctl enable sddm
EOS

echo "Desktop setup done!"