#!/bin/bash

# ============================================
# JustAGuy Linux - AwesomeWM Automated Setup Script
# https://github.com/drewgrif/awesomewm-setup
# ============================================

LOG_FILE="$HOME/justaguylinux-awesomewm-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Make script location-independent
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLONED_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/awesome"
INSTALL_DIR="$HOME/installation"
BUTTERSCRIPTS_REPO="https://github.com/drewgrif/butterscripts"

# Installation options
ONLY_CONFIG=false
EXPORT_PACKAGES=false

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        --only-config)
            ONLY_CONFIG=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --only-config       Only copy config files (skip all installations)"
            echo "  --export-packages   Export package lists for different distros and exit"
            echo "  --help              Show this help message"
            exit 0
            ;;
        --export-packages)
            EXPORT_PACKAGES=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ============================================
# Export Package Lists Function
# ============================================
export_packages() {
    echo "=== AwesomeWM Setup - Package Lists for Different Distributions ==="
    echo
    
    # Combine all packages
    local all_packages=(
        "${PACKAGES_CORE[@]}"
        "${PACKAGES_UI[@]}"
        "${PACKAGES_FILE_MANAGER[@]}"
        "${PACKAGES_AUDIO[@]}"
        "${PACKAGES_UTILITIES[@]}"
        "${PACKAGES_TERMINAL[@]}"
        "${PACKAGES_FONTS[@]}"
        "${PACKAGES_BUILD[@]}"
    )
    
    echo "DEBIAN/UBUNTU:"
    echo "sudo apt install ${all_packages[*]}"
    echo
    echo "Note: For firefox, use firefox-esr on Debian or firefox on Ubuntu"
    echo "Note: For modern ls, use exa on Debian 12 or eza on newer Ubuntu"
    echo
    
    # Arch equivalents
    local arch_packages=(
        "awesome"
        "xorg-server xorg-xinit xorg-xbacklight xbindkeys xvkbd xorg-xinput"
        "base-devel xdotool"
        "libnotify"
        "rofi dunst feh lxappearance network-manager-applet redshift"
        "thunar thunar-archive-plugin thunar-volman"
        "gvfs dialog mtools smbclient cifs-utils unzip"
        "pavucontrol pulsemixer pamixer pipewire-pulse"
        "avahi acpi acpid xfce4-power-manager"
        "flameshot qimgv firefox micro xdg-user-dirs-gtk lua-language-server"
        "suckless-tools eza"
        "ttf-font-awesome terminus-font"
        "cmake meson ninja curl pkgconf"
    )
    
    echo "ARCH LINUX:"
    echo "sudo pacman -S ${arch_packages[*]}"
    echo
    
    # Fedora equivalents
    local fedora_packages=(
        "awesome"
        "xorg-x11-server-Xorg xorg-x11-xinit xbacklight xbindkeys xvkbd xinput"
        "gcc make git xdotool"
        "libnotify libnotify-devel"
        "rofi dunst feh lxappearance NetworkManager-gnome redshift"
        "thunar thunar-archive-plugin thunar-volman"
        "gvfs dialog mtools samba-client cifs-utils unzip"
        "pavucontrol pulsemixer pamixer pipewire-pulseaudio"
        "avahi acpi acpid xfce4-power-manager"
        "flameshot qimgv firefox micro xdg-user-dirs-gtk lua-language-server"
        "eza"
        "fontawesome-fonts terminus-fonts"
        "cmake meson ninja-build curl pkgconfig"
    )
    
    echo "FEDORA:"
    echo "sudo dnf install ${fedora_packages[*]}"
    echo
    
    echo "NOTE: Some packages may have different names or may not be available"
    echo "in all distributions. You may need to:"
    echo "  - Find equivalent packages in your distro's repositories"
    echo "  - Install some tools from source"
    echo "  - Use alternative package managers (AUR for Arch, Flatpak, etc.)"
    echo
    echo "After installing packages, you can use:"
    echo "  $0 --only-config    # To copy just the AwesomeWM configuration files"
}

# Check if we should export packages and exit
if [ "$EXPORT_PACKAGES" = true ]; then
    export_packages
    exit 0
fi

# Create a unique base temporary directory for this run
MAIN_TEMP_DIR="/tmp/justaguylinux_awesomewm_$(date +%s)_$$"
mkdir -p "$MAIN_TEMP_DIR"

command_exists() {
    command -v "$1" &>/dev/null
}

# ============================================
# Error Handling and Utilities
# ============================================
die() {
    echo "ERROR: $*" >&2
    exit 1
}

msg() {
    echo "$*"
}

# ============================================
# Temporary Directory Management
# ============================================
create_temp_dir() {
    local name="$1"
    local temp_dir="$MAIN_TEMP_DIR/$name"
    mkdir -p "$temp_dir"
    echo "$temp_dir"
}

# Clean up all temporary directories on exit (success or failure)
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$MAIN_TEMP_DIR"
    rm -rf "$INSTALL_DIR"
    echo "Cleanup completed."
}
trap cleanup EXIT

# Butterscript helper
get_script() {
    wget -qO- "https://raw.githubusercontent.com/drewgrif/butterscripts/main/$1" | bash
}

# ============================================
# Confirm User Intention
# ============================================
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |a|w|e|s|o|m|e|w|m| |s|e|t|u|p|  
 +-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                            
"

if [ "$ONLY_CONFIG" = true ]; then
    echo "This script will copy AwesomeWM configuration files only."
else
    echo "This script will install and configure AwesomeWM on your Debian system."
fi

read -p "Do you want to continue? (y/n) " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && die "Installation aborted."

if [ "$ONLY_CONFIG" = false ]; then
    msg "Updating system..."
    sudo apt-get update && sudo apt-get upgrade -y
fi

# ============================================
# Package Arrays (Organized by Category)
# ============================================
PACKAGES_CORE=(
    awesome awesome-extra awesome-doc
    xorg xorg-dev xbacklight xbindkeys xvkbd xinput
    build-essential xdotool
    libnotify-bin libnotify-dev
)

PACKAGES_UI=(
    rofi dunst feh lxappearance network-manager-gnome redshift
)

PACKAGES_FILE_MANAGER=(
    thunar thunar-archive-plugin thunar-volman
    gvfs-backends dialog mtools smbclient cifs-utils unzip
)

PACKAGES_AUDIO=(
    pavucontrol pulsemixer pamixer pipewire-audio
)

PACKAGES_UTILITIES=(
    avahi-daemon acpi acpid xfce4-power-manager
    flameshot qimgv nala micro xdg-user-dirs-gtk lua-check
)

PACKAGES_TERMINAL=(
    suckless-tools
)

PACKAGES_FONTS=(
    fonts-recommended fonts-font-awesome fonts-terminus
)

PACKAGES_BUILD=(
    cmake meson ninja-build curl pkg-config
)

# ============================================
# Install Required Packages
# ============================================
install_packages() {
    if [ "$ONLY_CONFIG" = true ]; then
        msg "Skipping package installation..."
        return
    fi
    
    msg "Installing core packages..."
    sudo apt-get install -y "${PACKAGES_CORE[@]}" || die "Failed to install core packages"

    msg "Installing UI components..."
    sudo apt-get install -y "${PACKAGES_UI[@]}" || die "Failed to install UI packages"

    msg "Installing file manager..."
    sudo apt-get install -y "${PACKAGES_FILE_MANAGER[@]}" || die "Failed to install file manager"

    msg "Installing audio support..."
    sudo apt-get install -y "${PACKAGES_AUDIO[@]}" || die "Failed to install audio packages"

    msg "Installing system utilities..."
    sudo apt-get install -y "${PACKAGES_UTILITIES[@]}" || die "Failed to install utilities"
    
    # Try firefox-esr first (Debian), then firefox (Ubuntu)
    sudo apt-get install -y firefox-esr 2>/dev/null || sudo apt-get install -y firefox 2>/dev/null || msg "Note: firefox not available, skipping..."

    msg "Installing terminal tools..."
    sudo apt-get install -y "${PACKAGES_TERMINAL[@]}" || die "Failed to install terminal tools"
    
    # Try exa first (Debian 12), then eza (newer Ubuntu)
    sudo apt-get install -y exa 2>/dev/null || sudo apt-get install -y eza 2>/dev/null || msg "Note: exa/eza not available, skipping..."

    msg "Installing fonts..."
    sudo apt-get install -y "${PACKAGES_FONTS[@]}" || die "Failed to install fonts"

    msg "Installing build dependencies..."
    sudo apt-get install -y "${PACKAGES_BUILD[@]}" || die "Failed to install build tools"
    
    msg "Package installation completed."
}

# Build dependencies are now included in PACKAGES_BUILD array
# This function is kept for compatibility but is no longer needed
install_reqs() {
    # Build dependencies are installed as part of install_packages
    return
}

# ============================================
# Enable System Services
# ============================================
enable_services() {
    if [ "$ONLY_CONFIG" = true ]; then
        msg "Skipping service configuration..."
        return
    fi
    
    msg "Enabling required services..."
    sudo systemctl enable avahi-daemon acpid
}

# ============================================
# Set Up User Directories
# ============================================
setup_user_dirs() {
    msg "Updating user directories..."
    xdg-user-dirs-update
    mkdir -p ~/Screenshots/
    msg "User directories updated."
}

# ============================================
# Check for Existing AwesomeWM Config
# ============================================
check_awesomewm() {
    if [ -d "$CONFIG_DIR" ]; then
        echo "An existing ~/.config/awesome directory was found."
        read -p "Backup existing configuration? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            backup_dir="$HOME/.config/awesome_backup_$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$CONFIG_DIR" "$backup_dir" || die "Failed to backup existing config."
            echo "Backup saved to $backup_dir"
        fi
    fi
}

# ============================================
# Move Config Files
# ============================================
setup_awesomewm_config() {
    msg "Setting up configuration..."
    mkdir -p "$CONFIG_DIR"
    
    # Copy rc.lua
    cp "$CLONED_DIR/awesome/rc.lua" "$CONFIG_DIR/" || die "Failed to copy rc.lua"
    
    # Copy configuration directories
    for dir in modules themes wallpaper scripts picom rofi dunst; do
        if [ -d "$CLONED_DIR/awesome/$dir" ]; then
            cp -r "$CLONED_DIR/awesome/$dir" "$CONFIG_DIR/" || die "Failed to copy $dir"
        else
            msg "Warning: awesome/$dir directory not found, skipping..."
        fi
    done
    
    msg "AwesomeWM configuration files copied successfully."
}


# ============================================
# Main Execution
# ============================================
install_packages
install_reqs
enable_services
setup_user_dirs
check_awesomewm
setup_awesomewm_config

# Install essential components
if [ "$ONLY_CONFIG" = false ]; then
    mkdir -p "$MAIN_TEMP_DIR" && cd "$MAIN_TEMP_DIR"

    msg "Installing picom..."
    get_script "setup/install_picom.sh"

    msg "Installing wezterm..."
    get_script "wezterm/install_wezterm.sh"

    msg "Installing st terminal..."
    wget -O "$MAIN_TEMP_DIR/install_st.sh" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/st/install_st.sh"
    chmod +x "$MAIN_TEMP_DIR/install_st.sh"
    # Run in current terminal session to preserve interactivity
    bash "$MAIN_TEMP_DIR/install_st.sh"

    msg "Installing fonts..."
    get_script "theming/install_nerdfonts.sh"

    msg "Installing themes..."
    get_script "theming/install_theme.sh"

    msg "Downloading display manager installer..."
    wget -O "$MAIN_TEMP_DIR/install_lightdm.sh" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/system/install_lightdm.sh"
    chmod +x "$MAIN_TEMP_DIR/install_lightdm.sh"
    msg "Running display manager installer..."
    # Run in current terminal session to preserve interactivity
    bash "$MAIN_TEMP_DIR/install_lightdm.sh"

    # Bashrc configuration
    clear
    read -p "Replace your .bashrc with justaguylinux .bashrc? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        msg "Configuring bashrc..."
        get_script "system/add_bashrc.sh"
    fi

    # Optional tools
    clear
    read -p "Install optional tools (browsers, editors, etc)? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        msg "Downloading optional tools installer..."
        wget -O "$MAIN_TEMP_DIR/optional_tools.sh" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/setup/optional_tools.sh"
        chmod +x "$MAIN_TEMP_DIR/optional_tools.sh"
        msg "Running optional tools installer..."
        # Run in current terminal session to preserve interactivity
        if bash "$MAIN_TEMP_DIR/optional_tools.sh"; then
            msg "Optional tools completed successfully"
        else
            msg "Optional tools exited (this is normal if cancelled by user)"
        fi
    fi
else
    msg "Skipping external tool installation (--only-config mode)"
fi

echo
echo "All installations completed successfully!"
echo "Log out and select AwesomeWM from your display manager to start using it."
