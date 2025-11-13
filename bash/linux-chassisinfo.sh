#!/bin/bash

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# system info
host=$(hostnamectl --static)
mfg=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null | tr -d '-')
model=$(cat /sys/class/dmi/id/product_family 2>/dev/null | tr -d '-')
serialnum=$(cat /sys/class/dmi/id/product_serial 2>/dev/null | tr -d '-')
biosdate=$(cat /sys/class/dmi/id/bios_date 2>/dev/null | tr -d '-')
biosver=$(cat /sys/class/dmi/id/bios_version 2>/dev/null | tr -d '-')

check_empty() {
    [[ -z "$1" ]] && echo "N/A" || echo "$1"
}

echo "======================================================"
echo "                SYSTEM INFORMATION REPORT             "
echo "======================================================"
echo "Generated: $timestamp"
echo "------------------------------------------------------"
printf "%-15s : %s\n" "Hostname"      "$(check_empty "$host")"
printf "%-15s : %s\n" "Manufacturer"  "$(check_empty "$mfg")"
printf "%-15s : %s\n" "Model"         "$(check_empty "$model")"
printf "%-15s : %s\n" "Serial Number" "$(check_empty "$serialnum")"
printf "%-15s : %s\n" "BIOS Date"     "$(check_empty "$biosdate")"
printf "%-15s : %s\n" "BIOS Version"  "$(check_empty "$biosver")"
echo "======================================================"

