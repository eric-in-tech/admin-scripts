#!/bin/bash
keymap="/usr/share/kbd/keymaps/tabplus.map"

#create directory and keymap file
mkdir /usr/share/kbd
mkdir /usr/share/kbd/keymaps
touch $keymap
#Add the following lines:
#keycode 78 = Tab <-numpad Enter
#shift keycode 59 = F13 <- Shift+F1

BLOCK=$(cat <<EOF
keycode 78 = Tab
shift keycode 59 = F13
EOF
)
echo "$BLOCK" >> "$keymap"
cat $keymap

#Edit the KEYMAP value
sed -i "s|KEYMAP=\"us\"|KEYMAP=\"${keymap}\"|" /etc/vconsole.conf
cat /etc/vconsole.conf

exit 0
