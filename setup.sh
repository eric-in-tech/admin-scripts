#!/bin/bash

# menu item names
script1="Set hostname"
script2="NinjaOne agent install"
script3="Qualys agent install"
script4="SentinelOne agent install"
script5="OS config (autologon/grub)"
script6="Terminal ID (LUname) config"
script7="Sortation keymap config"

#colors/font
GREEN="\e[32m"
RED="\e[31m"
BGRED="\e[41m"
CYAN="\e[36m"
BOLD="\e[1m"
BLINK="\e[5m"
RESET="\e[0m"

check_empty() {
    [[ -z "$1" ]] && echo "N/A" || echo "$1"
}

# Function to get status info
get_status() {
    HOSTNAME=$(hostnamectl --static)

    if systemctl is-active ninjarmm-agent >/dev/null 2>&1; then
        NINJA_STATUS="${GREEN}Installed${RESET}"
    else
        NINJA_STATUS="${RED}Not Installed${RESET}"
    fi

    if systemctl is-active qualys-cloud-agent >/dev/null 2>&1; then
        QUALYS_STATUS="${GREEN}Installed${RESET}"
    else
        QUALYS_STATUS="${BGRED}Not Installed${RESET}"
    fi

    if systemctl is-active sentinelone >/dev/null 2>&1; then
        SENTINEL_STATUS="${GREEN}Installed${RESET}"
    else
        SENTINEL_STATUS="${BGRED}Not Installed${RESET}"
    fi

    if grep -q "loglevel=4" /etc/default/grub; then
        GRUB_STATUS="${GREEN}Configured${RESET}"
    else
        GRUB_STATUS="${BGRED}Unconfigured${RESET}"
    fi

    if grep -q "c3270 -model" /home/whsterm/.bashrc; then
        LU_STATUS="${GREEN}Configured${RESET}"
    else
        LU_STATUS="${BGRED}Unconfigured${RESET}"
    fi

    if grep -q "KEYMAP=\"/usr/share/kbd/keymaps/tabplus.map\"" /etc/vconsole.conf; then
        KEYMAP_STATUS="${GREEN}Sortation${RESET}"
    else
        KEYMAP_STATUS="${BGRED}Unconfigured${RESET}"
    fi
}

# Define the menu function
show_menu() {
    clear
    get_status
    echo -e "${CYAN}${BOLD}==============================${RESET}"
    printf "%-15s : %b%s\n" " Hostname"       "$(check_empty "$HOSTNAME")"
    printf "%-15s : %b%s\n" " NinjaOne Agent" "$(check_empty "$NINJA_STATUS")"
    printf "%-15s : %b%s\n" " Qualys Agent"   "$(check_empty "$QUALYS_STATUS")"
    printf "%-15s : %b%s\n" " SentinelOne"    "$(check_empty "$SENTINEL_STATUS")"
    printf "%-15s : %b%s\n" " Terminal ID"    "$(check_empty "$LU_STATUS")"
    printf "%-15s : %b%s\n" " Keymap"         "$(check_empty "$KEYMAP_STATUS")"
    echo -e "${CYAN}${BOLD}==============================${RESET}"
    echo -e "${CYAN}${BOLD}       MAIN MENU${RESET}"
    echo -e "${CYAN}${BOLD}==============================${RESET}"
    echo "1) $script1"
    echo "2) $script2"
    echo "3) $script3"
    echo "4) $script4"
    echo "5) $script5"
    echo "6) $script6"
    echo "7) $script7"
    echo "8) Exit"
    echo -e "${CYAN}${BOLD}==============================${RESET}"
}

# Loop until user chooses to exit
while true; do
    show_menu
    read -p "Choose an option [1-8]: " choice

    case $choice in
        1)
            echo -e "${BLINK}Running $script1...${RESET}"
            ./set-hostname.sh
            read -p "Press Enter to return to menu..."
            ;;
        2)
            echo "Running $script2..."
            ./ninja-install.sh
            read -p "Press Enter to return to menu..."
            ;;
        3)
            echo "Running $script3..."
            ./qualys-install.sh
            read -p "Press Enter to return to menu..."
            ;;
        4)
            echo "Running $script4..."
            ./sentinelone-install.sh
            read -p "Press Enter to return to menu..."
            ;;
        5)
            echo "Running $script5..."
            ./system-config.sh
            read -p "Press Enter to return to menu..."
            ;;
        6)
            echo "Running $script6..."
            ./terminalLU.sh
            read -p "Press Enter to return to menu..."
            ;;
        7)
            echo "Running $script7..."
            ./sortation-keymap.sh
            read -p "Press Enter to return to menu..."
            ;;
        8)
            echo "Exiting. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            ;;
    esac
done