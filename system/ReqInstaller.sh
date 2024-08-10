#!/bin/bash

# Color variables
RED='\033[0;31m'    # Red color
GREEN='\033[0;32m'  # Green color
YELLOW='\033[0;33m' # Yellow color
BLUE='\033[0;34m'   # Blue color
NC='\033[0m'        # No color

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run this script as root or use sudo.${NC}"
        exit 1
    fi
}

# Function to check for network connectivity
check_network() {
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}No network connection detected. Please check your internet connection.${NC}"
        exit 1
    fi
}

# Function to install packages using pacman
install_with_pacman() {
    echo -e "${BLUE}Detected Arch Linux. Installing dependencies using pacman...${NC}"
    sudo pacman -Syu
    sudo pacman -S --noconfirm python python-numpy python-scipy python-sounddevice python-evdev
    echo -e "${GREEN}Dependencies have been installed successfully using pacman.${NC}"
}

# Function to install packages using apt
install_with_apt() {
    echo -e "${BLUE}Detected Debian-based system. Installing dependencies using apt...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y python3 python3-numpy python3-scipy python3-sounddevice python3-evdev
    echo -e "${GREEN}Dependencies have been installed successfully using apt.${NC}"
}

# OS detection
check_root        # Check if running as root
check_network     # Check for network connection

if [ -f /etc/os-release ]; then
    # Source the OS release file
    . /etc/os-release
    case $ID in
        arch | archlinux)
            install_with_pacman
            ;;
        debian | ubuntu)
            install_with_apt
            ;;
        *)
            echo -e "${RED}Unsupported OS: $ID. This script supports Arch Linux and Debian-based systems only.${NC}"
            exit 1
            ;;
    esac
else
    echo -e "${RED}OS detection failed. Unable to determine the package manager.${NC}"
    exit 1
fi
