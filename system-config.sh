#!/bin/bash

echo "Set system options for warehouse terminal"

# set autologin with getty config
echo "Update getty tty1 to autologin as whsterm user"
ls /etc/systemd/system/getty.target.wants/getty\@tty1.service -l
cp /usr/lib/systemd/system/getty\@.service /usr/lib/systemd/system/getty\@tty1.service
ln -sf /usr/lib/systemd/system/getty\@tty1.service /etc/systemd/system/getty.target.wants/getty\@tty1.service
#vi /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo sed -i 's|^ExecStart=-/sbin/agetty .*|ExecStart=-/sbin/agetty -a whsterm -o '\''-p -- \\u'\'' --noclear - $TERM|' /usr/lib/systemd/system/getty@tty1.service

# set grub config
echo "Update grub boot options to silence console and set display to 640x480"
sudo sed -i 's|\(GRUB_CMDLINE_LINUX="\)\(.*\)"|\1\2 loglevel=4"|' /etc/default/grub
sudo sed -i "/^GRUB_CMDLINE_LINUX/i GRUB_CMDLINE_LINUX_DEFAULT=\"video=640x480\"" /etc/default/grub
sudo grub2-mkconfig --update-bls-cmdline -o /boot/grub2/grub.cfg

echo "System options set"
exit 0