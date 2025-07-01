#!/bin/bash

# Windows Utilities Script for Flutter Development
# Visual Studio tools and package management (for Windows Subsystem for Linux)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check if we're on Windows or WSL
check_windows_environment() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
        echo -e "${GREEN}✅ Windows environment detected${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  This script is optimized for Windows/WSL environments${NC}"
        echo -e "${YELLOW}Some features may not work on other platforms${NC}"
        return 1
    fi
}

# Check Visual Studio installation
check_visual_studio() {
    echo -e "${CYAN}🔍 Visual Studio Information${NC}"
    echo ""
    
    # Check for Visual Studio on Windows
    if command -v "/c/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" &> /dev/null; then
        echo -e "${YELLOW}📋 Visual Studio installations:${NC}"
        "/c/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -format text
    elif command -v vswhere.exe &> /dev/null; then
        echo -e "${YELLOW}📋 Visual Studio installations:${NC}"
        vswhere.exe -format text
    else
        echo -e "${RED}❌ Visual Studio not found${NC}"
        echo -e "${YELLOW}💡 Install Visual Studio Community from https://visualstudio.microsoft.com/${NC}"
    fi
    
    echo ""
    
    # Check for Visual Studio Code
    if command -v code &> /dev/null; then
        echo -e "${GREEN}✅ Visual Studio Code found${NC}"
        code --version
    else
        echo -e "${YELLOW}⚠️  Visual Studio Code not found${NC}"
    fi
}

# Windows development tools management
manage_windows_dev_tools() {
    echo -e "${CYAN}🛠️ Windows Development Tools${NC}"
    echo ""
    
    echo -e "${YELLOW}Select tool management:${NC}"
    echo -e "${GREEN}1.${NC} Install Chocolatey"
    echo -e "${GREEN}2.${NC} Install development tools via Chocolatey"
    echo -e "${GREEN}3.${NC} Install Scoop package manager"
    echo -e "${GREEN}4.${NC} Install development tools via Scoop"
    echo -e "${GREEN}5.${NC} Install Windows Terminal"
    echo -e "${GREEN}6.${NC} Setup PowerShell profile"
    echo ""
    read -p "Enter choice (1-6): " tool_choice
    
    case $tool_choice in
        1)
            echo -e "${YELLOW}🍫 Installing Chocolatey...${NC}"
            if command -v choco &> /dev/null; then
                echo -e "${GREEN}✅ Chocolatey already installed${NC}"
            else
                echo -e "${YELLOW}Installing Chocolatey (requires PowerShell as Administrator)${NC}"
                echo "Run this in PowerShell as Administrator:"
                echo "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
            fi
            ;;
        2)
            echo -e "${YELLOW}📦 Installing development tools via Chocolatey...${NC}"
            if command -v choco &> /dev/null; then
                echo -e "${YELLOW}Installing Git, Node.js, Flutter, and VS Code...${NC}"
                echo "Run these commands in PowerShell as Administrator:"
                echo "choco install git nodejs flutter vscode -y"
            else
                echo -e "${RED}❌ Chocolatey not found. Install Chocolatey first.${NC}"
            fi
            ;;
        3)
            echo -e "${YELLOW}🥄 Installing Scoop...${NC}"
            if command -v scoop &> /dev/null; then
                echo -e "${GREEN}✅ Scoop already installed${NC}"
            else
                echo "Run this in PowerShell:"
                echo "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
                echo "Invoke-RestMethod get.scoop.sh | Invoke-Expression"
            fi
            ;;
        4)
            echo -e "${YELLOW}📦 Installing development tools via Scoop...${NC}"
            if command -v scoop &> /dev/null; then
                echo "Run these commands in PowerShell:"
                echo "scoop bucket add extras"
                echo "scoop install git nodejs-lts flutter vscode"
            else
                echo -e "${RED}❌ Scoop not found. Install Scoop first.${NC}"
            fi
            ;;
        5)
            echo -e "${YELLOW}📱 Installing Windows Terminal...${NC}"
            echo "Install from Microsoft Store or run:"
            echo "winget install --id Microsoft.WindowsTerminal -e"
            ;;
        6)
            echo -e "${YELLOW}⚙️ Setting up PowerShell profile...${NC}"
            echo "Run this in PowerShell:"
            echo "if (!(Test-Path -Path \$PROFILE)) { New-Item -ItemType File -Path \$PROFILE -Force }"
            echo "notepad \$PROFILE"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Flutter Windows-specific setup
flutter_windows_setup() {
    echo -e "${CYAN}📱 Flutter Windows Setup${NC}"
    echo ""
    
    echo -e "${YELLOW}Select Flutter Windows action:${NC}"
    echo -e "${GREEN}1.${NC} Check Flutter Windows requirements"
    echo -e "${GREEN}2.${NC} Enable Windows desktop"
    echo -e "${GREEN}3.${NC} Build Windows app"
    echo -e "${GREEN}4.${NC} Install Visual Studio Build Tools"
    echo ""
    read -p "Enter choice (1-4): " flutter_choice
    
    case $flutter_choice in
        1)
            echo -e "${YELLOW}🔍 Checking Flutter Windows requirements...${NC}"
            flutter doctor -v
            echo ""
            echo -e "${YELLOW}Required for Windows development:${NC}"
            echo "• Visual Studio 2019 or later (with C++ tools)"
            echo "• Windows 10 SDK"
            echo "• CMake and Visual Studio Code"
            ;;
        2)
            echo -e "${YELLOW}🖥️ Enabling Windows desktop...${NC}"
            flutter config --enable-windows-desktop
            echo -e "${GREEN}✅ Windows desktop enabled${NC}"
            ;;
        3)
            echo -e "${YELLOW}🔨 Building Windows app...${NC}"
            if [ -f "pubspec.yaml" ]; then
                flutter build windows
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Windows app built successfully${NC}"
                    echo -e "${YELLOW}📍 Location: build/windows/runner/Release/${NC}"
                fi
            else
                echo -e "${RED}❌ Not in a Flutter project directory${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}🔧 Visual Studio Build Tools installation:${NC}"
            echo "Download and install Visual Studio Build Tools from:"
            echo "https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019"
            echo ""
            echo "Make sure to install:"
            echo "• MSVC v142 - VS 2019 C++ x64/x86 build tools"
            echo "• Windows 10 SDK"
            echo "• CMake tools for Visual Studio"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Windows system information
show_windows_system_info() {
    echo -e "${CYAN}💻 Windows System Information${NC}"
    echo ""
    
    # Check if we're in WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo -e "${YELLOW}📋 WSL Environment detected${NC}"
        echo ""
        
        echo -e "${YELLOW}📋 WSL Version:${NC}"
        cat /proc/version
        echo ""
        
        echo -e "${YELLOW}📋 Distribution:${NC}"
        lsb_release -a 2>/dev/null || cat /etc/os-release
        echo ""
        
        echo -e "${YELLOW}📋 Memory Usage:${NC}"
        free -h
        echo ""
        
        echo -e "${YELLOW}📋 Disk Usage:${NC}"
        df -h
        echo ""
    else
        echo -e "${YELLOW}📋 System Information:${NC}"
        if command -v systeminfo &> /dev/null; then
            systeminfo | head -20
        else
            uname -a
        fi
    fi
    
    echo -e "${YELLOW}📋 Network Configuration:${NC}"
    if command -v ipconfig &> /dev/null; then
        ipconfig | grep -A 3 "IPv4"
    else
        ip addr show | grep "inet " | head -5
    fi
}

# Windows environment variables
manage_environment_variables() {
    echo -e "${CYAN}🌍 Environment Variables Management${NC}"
    echo ""
    
    echo -e "${YELLOW}Select action:${NC}"
    echo -e "${GREEN}1.${NC} Show PATH variable"
    echo -e "${GREEN}2.${NC} Show Flutter environment variables"
    echo -e "${GREEN}3.${NC} Show all environment variables"
    echo -e "${GREEN}4.${NC} Add directory to PATH (current session)"
    echo ""
    read -p "Enter choice (1-4): " env_choice
    
    case $env_choice in
        1)
            echo -e "${YELLOW}📋 PATH variable:${NC}"
            echo $PATH | tr ':' '\n'
            ;;
        2)
            echo -e "${YELLOW}📋 Flutter environment variables:${NC}"
            env | grep -i flutter || echo "No Flutter environment variables found"
            echo ""
            echo -e "${YELLOW}📋 ANDROID environment variables:${NC}"
            env | grep -i android || echo "No Android environment variables found"
            ;;
        3)
            echo -e "${YELLOW}📋 All environment variables:${NC}"
            env | sort
            ;;
        4)
            read -p "Enter directory path to add to PATH: " dir_path
            if [ -d "$dir_path" ]; then
                export PATH="$PATH:$dir_path"
                echo -e "${GREEN}✅ Added $dir_path to PATH (current session only)${NC}"
                echo -e "${YELLOW}💡 To make permanent, add to your shell profile${NC}"
            else
                echo -e "${RED}❌ Directory not found: $dir_path${NC}"
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Windows package management
windows_package_management() {
    echo -e "${CYAN}📦 Windows Package Management${NC}"
    echo ""
    
    echo -e "${YELLOW}Available package managers:${NC}"
    echo ""
    
    # Check Chocolatey
    if command -v choco &> /dev/null; then
        echo -e "${GREEN}✅ Chocolatey (choco)${NC}"
        choco --version
    else
        echo -e "${RED}❌ Chocolatey not installed${NC}"
    fi
    
    # Check Scoop
    if command -v scoop &> /dev/null; then
        echo -e "${GREEN}✅ Scoop${NC}"
        scoop --version
    else
        echo -e "${RED}❌ Scoop not installed${NC}"
    fi
    
    # Check winget
    if command -v winget &> /dev/null; then
        echo -e "${GREEN}✅ Windows Package Manager (winget)${NC}"
        winget --version
    else
        echo -e "${RED}❌ winget not available${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Select action:${NC}"
    echo -e "${GREEN}1.${NC} Update all Chocolatey packages"
    echo -e "${GREEN}2.${NC} Update all Scoop packages"
    echo -e "${GREEN}3.${NC} Search for a package"
    echo -e "${GREEN}4.${NC} Install Flutter dependencies"
    echo ""
    read -p "Enter choice (1-4): " package_choice
    
    case $package_choice in
        1)
            if command -v choco &> /dev/null; then
                echo -e "${YELLOW}📦 Updating Chocolatey packages...${NC}"
                echo "Run: choco upgrade all -y"
            else
                echo -e "${RED}❌ Chocolatey not found${NC}"
            fi
            ;;
        2)
            if command -v scoop &> /dev/null; then
                echo -e "${YELLOW}📦 Updating Scoop packages...${NC}"
                scoop update *
            else
                echo -e "${RED}❌ Scoop not found${NC}"
            fi
            ;;
        3)
            read -p "Enter package name to search: " package_name
            echo -e "${YELLOW}🔍 Searching for: $package_name${NC}"
            
            if command -v choco &> /dev/null; then
                echo -e "${BLUE}Chocolatey results:${NC}"
                choco search "$package_name"
            fi
            
            if command -v scoop &> /dev/null; then
                echo -e "${BLUE}Scoop results:${NC}"
                scoop search "$package_name"
            fi
            ;;
        4)
            echo -e "${YELLOW}📦 Installing Flutter dependencies...${NC}"
            echo "Common Flutter dependencies for Windows:"
            echo "• git"
            echo "• android-sdk"
            echo "• flutter"
            echo "• vscode"
            echo ""
            echo "Install with Chocolatey:"
            echo "choco install git android-sdk flutter vscode -y"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Windows firewall and network
windows_network_tools() {
    echo -e "${CYAN}🌐 Windows Network Tools${NC}"
    echo ""
    
    echo -e "${YELLOW}Select network tool:${NC}"
    echo -e "${GREEN}1.${NC} Check network connectivity"
    echo -e "${GREEN}2.${NC} Show network interfaces"
    echo -e "${GREEN}3.${NC} Test Flutter network requirements"
    echo -e "${GREEN}4.${NC} Check Windows Defender Firewall"
    echo ""
    read -p "Enter choice (1-4): " network_choice
    
    case $network_choice in
        1)
            echo -e "${YELLOW}🌐 Testing network connectivity...${NC}"
            echo "Testing Google DNS..."
            ping -c 4 8.8.8.8 2>/dev/null || ping -n 4 8.8.8.8
            echo ""
            echo "Testing pub.dev..."
            ping -c 2 pub.dev 2>/dev/null || ping -n 2 pub.dev
            ;;
        2)
            echo -e "${YELLOW}📡 Network interfaces:${NC}"
            if command -v ipconfig &> /dev/null; then
                ipconfig /all
            else
                ip addr show
            fi
            ;;
        3)
            echo -e "${YELLOW}🔍 Testing Flutter network requirements...${NC}"
            echo "Testing Flutter repository access..."
            curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json > /dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Flutter repository accessible${NC}"
            else
                echo -e "${RED}❌ Flutter repository not accessible${NC}"
            fi
            
            echo "Testing pub.dev access..."
            curl -s https://pub.dev > /dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ pub.dev accessible${NC}"
            else
                echo -e "${RED}❌ pub.dev not accessible${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}🛡️ Windows Defender Firewall status:${NC}"
            echo "Check firewall status with:"
            echo "netsh advfirewall show allprofiles"
            echo ""
            echo "If Flutter/Android development is blocked, consider adding firewall rules for:"
            echo "• Flutter tools"
            echo "• Android SDK tools"
            echo "• Development servers (ports 8080, 3000, etc.)"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Show Windows utilities menu
show_windows_menu() {
    echo -e "${CYAN}🪟 Windows Utilities for Flutter Development${NC}"
    echo ""
    echo -e "${WHITE}Development Environment:${NC}"
    echo -e "${GREEN}1.${NC} Visual Studio Information"
    echo -e "${GREEN}2.${NC} Windows Development Tools"
    echo -e "${GREEN}3.${NC} Flutter Windows Setup"
    echo ""
    echo -e "${WHITE}System Management:${NC}"
    echo -e "${GREEN}4.${NC} System Information"
    echo -e "${GREEN}5.${NC} Environment Variables"
    echo -e "${GREEN}6.${NC} Package Management"
    echo -e "${GREEN}7.${NC} Network Tools"
    echo ""
    read -p "Enter choice (1-7): " windows_choice
    
    case $windows_choice in
        1) check_visual_studio ;;
        2) manage_windows_dev_tools ;;
        3) flutter_windows_setup ;;
        4) show_windows_system_info ;;
        5) manage_environment_variables ;;
        6) windows_package_management ;;
        7) windows_network_tools ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    check_windows_environment
    
    case ${1:-"menu"} in
        "vs") check_visual_studio ;;
        "tools") manage_windows_dev_tools ;;
        "flutter") flutter_windows_setup ;;
        "system") show_windows_system_info ;;
        "env") manage_environment_variables ;;
        "packages") windows_package_management ;;
        "network") windows_network_tools ;;
        *) show_windows_menu ;;
    esac
}

main "$@"