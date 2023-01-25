#! /usr/bin/bash

function install_gnome() {
  arch-chroot /mnt /bin/bash << EOS
pacman -S --noconfirm gnome
systemctl enable gdm
EOS
}

function install_kde() {
  arch-chroot /mnt /bin/bash << EOS
pacman -S --noconfirm plasma
systemctl enable sddm
EOS
}

echo "----------------Desktop setup-----------------"
echo "What desktop environment do you want?"
echo -ne "
1. Gnome
2. KDE Plasma
3. None
"
read de
case $de in
  [1]* )
    echo "Installing Gnome"
    install_gnome
    return 0
    ;;
  [2]* )
    echo "Installing Plasma"
    install_kde
    return 0
    ;;
  [3]*
    echo "Not installing desktop environment"
    return 0
    ;;
esac

echo "Desktop setup done!"