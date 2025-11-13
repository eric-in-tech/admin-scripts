#!/bin/bash
# adds the c3270 block to a default .bashrc for the whsterm user

BASHRC="/home/whsterm/.bashrc"

# Prompt for Terminal ID
read -p "Enter the terminal ID (session/LU): " TERM_ID

# Define the block to append
BLOCK=$(cat <<EOF
until ping -c1 172.28.0.1 &>/dev/null; do :; done
echo "Waiting for network."
echo "Connecting in 5 seconds..."
sleep 5
c3270 -model 3279-2 $TERM_ID@mf3270.fcs.lan:23 -reconnect
EOF
)

# Check if block already exists
if grep -q "c3270 -model 3279-2" "$BASHRC"; then
    echo "Block already exists in $BASHRC. No changes made."
else
    echo "$BLOCK" >> "$BASHRC"
    echo "Block appended to $BASHRC successfully."
fi