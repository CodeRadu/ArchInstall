#! /usr/bin/bash

echo "----------------Installing DE-----------------"
arch-chroot /mnt /bin/bash << EOS
pacman -S --noconfirm plasma
pacman -S --noconfirm chromium kitty

systemctl enable sddm
EOS

echo "Desktop setup done!"