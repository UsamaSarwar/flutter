#!/bin/bash

# macOS Utilities Script for Flutter Development
# Xcode management and iOS Simulator management

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check if we're on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ Error: This script is only available on macOS!${NC}"
        exit 1
    fi
}

# Check Xcode installation
check_xcode() {
    if ! command -v xcodebuild &> /dev/null; then
        echo -e "${RED}❌ Xcode not found!${NC}"
        echo -e "${YELLOW}💡 Install Xcode from App Store${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Xcode found${NC}"
}

# Show Xcode information
show_xcode_info() {
    echo -e "${CYAN}🔍 Xcode Information${NC}"
    echo ""
    
    check_xcode
    
    echo -e "${YELLOW}📋 Xcode Version:${NC}"
    xcodebuild -version
    echo ""
    
    echo -e "${YELLOW}📋 Xcode Path:${NC}"
    xcode-select -p
    echo ""
    
    echo -e "${YELLOW}📋 Available SDKs:${NC}"
    xcodebuild -showsdks | grep -E "(iOS|macOS|watchOS|tvOS)"
    echo ""
    
    echo -e "${YELLOW}📋 Command Line Tools:${NC}"
    if xcode-select -p &>/dev/null; then
        echo -e "${GREEN}✅ Command Line Tools installed${NC}"
    else
        echo -e "${RED}❌ Command Line Tools not installed${NC}"
        echo -e "${YELLOW}💡 Install with: xcode-select --install${NC}"
    fi
}

# Manage Xcode versions
manage_xcode_versions() {
    echo -e "${CYAN}🔧 Xcode Version Management${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Current Xcode path:${NC}"
    xcode-select -p
    echo ""
    
    echo -e "${YELLOW}📋 Available Xcode installations:${NC}"
    find /Applications -name "Xcode*.app" -maxdepth 1 2>/dev/null
    echo ""
    
    echo -e "${YELLOW}Select action:${NC}"
    echo -e "${GREEN}1.${NC} Switch Xcode version"
    echo -e "${GREEN}2.${NC} Install Command Line Tools"
    echo -e "${GREEN}3.${NC} Reset Xcode settings"
    echo ""
    read -p "Enter choice (1-3): " xcode_choice
    
    case $xcode_choice in
        1)
            echo -e "${YELLOW}Enter path to Xcode.app:${NC}"
            read -p "Path: " xcode_path
            if [ -d "$xcode_path" ]; then
                sudo xcode-select -s "$xcode_path"
                echo -e "${GREEN}✅ Xcode path switched to: $xcode_path${NC}"
            else
                echo -e "${RED}❌ Xcode not found at: $xcode_path${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}📦 Installing Command Line Tools...${NC}"
            xcode-select --install
            ;;
        3)
            echo -e "${YELLOW}🔄 Resetting Xcode settings...${NC}"
            sudo xcode-select --reset
            echo -e "${GREEN}✅ Xcode settings reset${NC}"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# iOS Simulator management
manage_ios_simulators() {
    echo -e "${CYAN}📱 iOS Simulator Management${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Available simulators:${NC}"
    xcrun simctl list devices available
    echo ""
    
    echo -e "${YELLOW}Select action:${NC}"
    echo -e "${GREEN}1.${NC} Launch specific simulator"
    echo -e "${GREEN}2.${NC} Boot simulator"
    echo -e "${GREEN}3.${NC} Shutdown simulator"
    echo -e "${GREEN}4.${NC} Reset simulator"
    echo -e "${GREEN}5.${NC} Create new simulator"
    echo -e "${GREEN}6.${NC} Delete simulator"
    echo -e "${GREEN}7.${NC} Install app on simulator"
    echo ""
    read -p "Enter choice (1-7): " sim_choice
    
    case $sim_choice in
        1)
            echo -e "${YELLOW}📱 Available simulators:${NC}"
            xcrun simctl list devices available | grep -E "iPhone|iPad"
            echo ""
            read -p "Enter simulator UDID or name: " sim_id
            echo -e "${YELLOW}🚀 Launching simulator...${NC}"
            xcrun simctl boot "$sim_id" 2>/dev/null
            open -a Simulator
            ;;
        2)
            read -p "Enter simulator UDID: " sim_id
            echo -e "${YELLOW}🔄 Booting simulator...${NC}"
            xcrun simctl boot "$sim_id"
            ;;
        3)
            read -p "Enter simulator UDID (or 'all' for all): " sim_id
            if [ "$sim_id" = "all" ]; then
                echo -e "${YELLOW}🛑 Shutting down all simulators...${NC}"
                xcrun simctl shutdown all
            else
                echo -e "${YELLOW}🛑 Shutting down simulator...${NC}"
                xcrun simctl shutdown "$sim_id"
            fi
            ;;
        4)
            read -p "Enter simulator UDID: " sim_id
            echo -e "${YELLOW}🔄 Resetting simulator...${NC}"
            xcrun simctl erase "$sim_id"
            ;;
        5)
            echo -e "${YELLOW}📋 Available device types:${NC}"
            xcrun simctl list devicetypes | grep -E "iPhone|iPad"
            echo ""
            read -p "Enter device type (e.g., iPhone 14): " device_type
            read -p "Enter runtime (e.g., iOS 16.0): " runtime
            read -p "Enter simulator name: " sim_name
            
            echo -e "${YELLOW}🔨 Creating simulator...${NC}"
            xcrun simctl create "$sim_name" "$device_type" "$runtime"
            ;;
        6)
            read -p "Enter simulator UDID to delete: " sim_id
            echo -e "${YELLOW}🗑️ Deleting simulator...${NC}"
            xcrun simctl delete "$sim_id"
            ;;
        7)
            read -p "Enter simulator UDID: " sim_id
            read -p "Enter path to .app bundle: " app_path
            if [ -d "$app_path" ]; then
                echo -e "${YELLOW}📦 Installing app...${NC}"
                xcrun simctl install "$sim_id" "$app_path"
            else
                echo -e "${RED}❌ App bundle not found: $app_path${NC}"
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# macOS development tools
macos_dev_tools() {
    echo -e "${CYAN}🛠️ macOS Development Tools${NC}"
    echo ""
    
    echo -e "${YELLOW}Select tool:${NC}"
    echo -e "${GREEN}1.${NC} Install Homebrew"
    echo -e "${GREEN}2.${NC} Install common development tools"
    echo -e "${GREEN}3.${NC} Install Flutter via Homebrew"
    echo -e "${GREEN}4.${NC} Setup Git configuration"
    echo -e "${GREEN}5.${NC} Install VS Code extensions"
    echo ""
    read -p "Enter choice (1-5): " tool_choice
    
    case $tool_choice in
        1)
            echo -e "${YELLOW}🍺 Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ;;
        2)
            echo -e "${YELLOW}🔧 Installing development tools...${NC}"
            if command -v brew &> /dev/null; then
                brew install git node npm yarn cocoapods
                echo -e "${GREEN}✅ Development tools installed${NC}"
            else
                echo -e "${RED}❌ Homebrew not found. Install Homebrew first.${NC}"
            fi
            ;;
        3)
            echo -e "${YELLOW}📱 Installing Flutter via Homebrew...${NC}"
            if command -v brew &> /dev/null; then
                brew install --cask flutter
                echo -e "${GREEN}✅ Flutter installed${NC}"
            else
                echo -e "${RED}❌ Homebrew not found${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}⚙️ Setting up Git configuration...${NC}"
            read -p "Enter your name: " git_name
            read -p "Enter your email: " git_email
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            echo -e "${GREEN}✅ Git configuration completed${NC}"
            ;;
        5)
            echo -e "${YELLOW}📝 Installing VS Code extensions...${NC}"
            if command -v code &> /dev/null; then
                code --install-extension Dart-Code.flutter
                code --install-extension Dart-Code.dart-code
                echo -e "${GREEN}✅ VS Code extensions installed${NC}"
            else
                echo -e "${RED}❌ VS Code not found${NC}"
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# System information
show_system_info() {
    echo -e "${CYAN}💻 System Information${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 macOS Version:${NC}"
    sw_vers
    echo ""
    
    echo -e "${YELLOW}📋 Hardware:${NC}"
    system_profiler SPHardwareDataType | grep -E "(Model Name|Model Identifier|Processor|Memory|Serial Number)"
    echo ""
    
    echo -e "${YELLOW}📋 Disk Usage:${NC}"
    df -h / | tail -1
    echo ""
    
    echo -e "${YELLOW}📋 Memory Usage:${NC}"
    vm_stat | head -5
    echo ""
    
    echo -e "${YELLOW}📋 Network:${NC}"
    ifconfig en0 | grep "inet " | awk '{print "IP Address: " $2}'
}

# Clean development cache
clean_dev_cache() {
    echo -e "${CYAN}🧹 Clean Development Cache${NC}"
    echo ""
    
    echo -e "${YELLOW}Select cache to clean:${NC}"
    echo -e "${GREEN}1.${NC} Xcode cache"
    echo -e "${GREEN}2.${NC} iOS Simulator cache"
    echo -e "${GREEN}3.${NC} Homebrew cache"
    echo -e "${GREEN}4.${NC} npm cache"
    echo -e "${GREEN}5.${NC} All caches"
    echo ""
    read -p "Enter choice (1-5): " cache_choice
    
    case $cache_choice in
        1|5)
            echo -e "${YELLOW}🧹 Cleaning Xcode cache...${NC}"
            rm -rf ~/Library/Developer/Xcode/DerivedData/*
            rm -rf ~/Library/Caches/com.apple.dt.Xcode/*
            echo -e "${GREEN}✅ Xcode cache cleaned${NC}"
            ;;
    esac
    
    case $cache_choice in
        2|5)
            echo -e "${YELLOW}🧹 Cleaning iOS Simulator cache...${NC}"
            xcrun simctl erase all
            echo -e "${GREEN}✅ iOS Simulator cache cleaned${NC}"
            ;;
    esac
    
    case $cache_choice in
        3|5)
            if command -v brew &> /dev/null; then
                echo -e "${YELLOW}🧹 Cleaning Homebrew cache...${NC}"
                brew cleanup
                echo -e "${GREEN}✅ Homebrew cache cleaned${NC}"
            fi
            ;;
    esac
    
    case $cache_choice in
        4|5)
            if command -v npm &> /dev/null; then
                echo -e "${YELLOW}🧹 Cleaning npm cache...${NC}"
                npm cache clean --force
                echo -e "${GREEN}✅ npm cache cleaned${NC}"
            fi
            ;;
    esac
}

# Certificate and provisioning management
manage_certificates() {
    echo -e "${CYAN}🔑 Certificate & Provisioning Management${NC}"
    echo ""
    
    echo -e "${YELLOW}Select action:${NC}"
    echo -e "${GREEN}1.${NC} List keychains"
    echo -e "${GREEN}2.${NC} List certificates"
    echo -e "${GREEN}3.${NC} Import certificate"
    echo -e "${GREEN}4.${NC} List provisioning profiles"
    echo -e "${GREEN}5.${NC} Open Keychain Access"
    echo ""
    read -p "Enter choice (1-5): " cert_choice
    
    case $cert_choice in
        1)
            echo -e "${YELLOW}🔑 Available keychains:${NC}"
            security list-keychains
            ;;
        2)
            echo -e "${YELLOW}🔑 Available certificates:${NC}"
            security find-identity -v -p codesigning
            ;;
        3)
            read -p "Enter path to certificate (.p12): " cert_path
            if [ -f "$cert_path" ]; then
                echo -e "${YELLOW}🔑 Importing certificate...${NC}"
                security import "$cert_path" -k ~/Library/Keychains/login.keychain
            else
                echo -e "${RED}❌ Certificate not found: $cert_path${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}📄 Provisioning profiles:${NC}"
            ls -la "$HOME/Library/MobileDevice/Provisioning Profiles/" 2>/dev/null || echo "No profiles found"
            ;;
        5)
            echo -e "${YELLOW}🔑 Opening Keychain Access...${NC}"
            open -a "Keychain Access"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Show macOS utilities menu
show_macos_menu() {
    echo -e "${CYAN}🍎 macOS Utilities for Flutter Development${NC}"
    echo ""
    echo -e "${WHITE}Xcode Management:${NC}"
    echo -e "${GREEN}1.${NC} Xcode Information"
    echo -e "${GREEN}2.${NC} Manage Xcode Versions"
    echo -e "${GREEN}3.${NC} Certificate Management"
    echo ""
    echo -e "${WHITE}iOS Simulator:${NC}"
    echo -e "${GREEN}4.${NC} Manage iOS Simulators"
    echo ""
    echo -e "${WHITE}Development Tools:${NC}"
    echo -e "${GREEN}5.${NC} macOS Development Tools"
    echo -e "${GREEN}6.${NC} System Information"
    echo -e "${GREEN}7.${NC} Clean Development Cache"
    echo ""
    read -p "Enter choice (1-7): " macos_choice
    
    case $macos_choice in
        1) show_xcode_info ;;
        2) manage_xcode_versions ;;
        3) manage_certificates ;;
        4) manage_ios_simulators ;;
        5) macos_dev_tools ;;
        6) show_system_info ;;
        7) clean_dev_cache ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    check_macos
    
    case ${1:-"menu"} in
        "xcode") show_xcode_info ;;
        "simulators") manage_ios_simulators ;;
        "tools") macos_dev_tools ;;
        "system") show_system_info ;;
        "clean") clean_dev_cache ;;
        "certificates") manage_certificates ;;
        *) show_macos_menu ;;
    esac
}

main "$@"