#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display uptime
show_uptime() {
  echo -e "${YELLOW}Uptime:${NC}"
  uptime | awk '{printf "%-15s %-15s %-15s\n", "System Uptime:", $3, $4}'
}

# Function to display disk usage
show_disk_usage() {
  echo -e "${YELLOW}Disk Usage:${NC}"
  df -h | awk 'NR==1 {printf "%-15s %-15s %-15s\n", "Filesystem", "Size", "Used"} NR>1 {printf "%-15s %-15s %-15s\n", $1, $2, $3}'
}

# Function to display hard disk health and usage in a table
show_hard_disk_health() {
  echo -e "${YELLOW}Hard Disk Health and Usage:${NC}"
  # List all disks
  disks=$(lsblk -o NAME -nr | grep -E '^sd|^hd|^vd')
  # Loop through disks and display health and usage info
  for disk in $disks; do
    echo -e "${GREEN}Disk: $disk${NC}"
    # Display disk health using smartctl
    smartctl -H /dev/$disk | awk '/overall-health/ {print "Health:", $NF}'
    # Display disk usage
    df -h /dev/$disk | awk 'NR==2 {printf "%-15s %-15s %-15s\n", "Size:", $2, "Used: " $3}'
    echo ""
  done | column -t
}

# Function to display RAM usage
show_ram_usage() {
  echo -e "${YELLOW}Ram Usage:${NC}"
  free -h | awk '/Mem:/ {printf "%-15s %-15s %-15s\n", "Total Memory:", $2, "Used Memory: " $3}'


}


# Function to display CPU load
show_cpu_load() {
  echo -e "${YELLOW}CPU Load:${NC}"
  top -bn1 | awk '/Cpu/ {printf "%-15s %-15s\n", "CPU Load:", $2}'
}

# Function to display computer health (temperature, fan speed, battery status, etc.)
show_computer_health() {
  echo -e "${YELLOW}Computer Health:${NC}"
  # Display temperature (example using lm-sensors)
  sensors | awk '/^Core/ {printf "%-15s %-15s\n", "Temperature:", $3}'
  # Display fan speeds (example using lm-sensors)
  sensors | awk '/fan/ {printf "%-15s %-15s\n", "Fan Speed:", $2}'
  # Display battery status (example using acpi)
  acpi -b | awk '{printf "%-15s %-15s\n", "Battery:", $4}'
}

# Function to display connected USB devices
show_usb_devices() {
  echo -e "${YELLOW}USB Device:${NC}"
  lsusb | awk '{print "USB Device:", $6, $7, $8, $9}'
}

# Function to display colored header
header() {
  echo -e "${GREEN}===== System Status =====${NC}"
}

# Main function to display system status based on arguments
show_system_status() {
  header
  if [[ $# -eq 0 || "$1" == "all" ]]; then
    show_uptime
    echo ""
    show_disk_usage
    echo ""
    show_hard_disk_health
    echo ""
    show_ram_usage
    echo ""
    show_cpu_load
    echo ""
    show_computer_health
    echo ""
    show_usb_devices
  else
    for arg in "$@"; do
      case "$arg" in
        "uptime") show_uptime ;;
        "disk") show_disk_usage ;;
        "health") show_hard_disk_health ;;
        "ram") show_ram_usage ;;
        "cpu") show_cpu_load ;;
        "computer") show_computer_health ;;
        "usb") show_usb_devices ;;
        *) echo "Invalid argument: $arg" ;;
      esac
      echo ""
    done
  fi
}

# Call the main function to display system status based on arguments
show_system_status "$@"

