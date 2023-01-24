#! /usr/bin/bash

echo "-----------------Install sudo-----------------"
arch-chroot /mnt /bin/bash << EOS
pacman -S --noconfirm sudo chpasswd
echo "%sudo ALL=(ALL:ALL) ALL >> /etc/sudoers
groupadd sudo
EOS

echo "-----------------Creating user----------------"
echo "Enter your username:"
read username
echo "Enter your password (WILL be echoed)"
read password
arch-chroot /mnt /bin/bash << EOS
useradd -m $username
echo "$username:$password" | chpasswd
EOS

echo "-------------Machine configuration------------"
echo "Enter hostname:"
read hostname
arch-chroot /mnt /bin/bash << EOS
echo $hostname > /etc/hostname
EOS
echo "Enter your timezone (e.g Europe/Berlin)"
read timezone
arch-chroot /mnt /bin/bash << EOS
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
EOS

echo "User setup done!"