#!/bin/bash

# Check if user has root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

# Check if input ISO file is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 path_to_iso_file /dev/usb_device"
  exit 1
fi

iso_file="$1"
usb_device="$2"

# Verify if the ISO file exists
if [ ! -f "$iso_file" ]; then
  echo "Error: ISO file not found."
  exit 1
fi

# Verify if the USB device exists and is not mounted
if [ ! -b "$usb_device" ]; then
  echo "Error: USB device not found."
  exit 1
fi

# Unmount the USB device if it's mounted
umount "$usb_device" >/dev/null 2>&1

# Write the ISO file to the USB device using dd
echo "Writing $iso_file to $usb_device. Please wait..."
dd if="$iso_file" of="$usb_device" bs=4M status=progress && sync

echo "ISO file has been written to the USB flash drive successfully."
