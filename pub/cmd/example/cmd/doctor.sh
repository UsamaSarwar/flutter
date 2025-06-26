#!/bin/bash

# Flutter Doctor & Environment Script
# Compatible with Flutter 3.x and latest versions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Main doctor function
main_doctor() {
    echo -e "${CYAN}🏥 Flutter Doctor & Environment Check${NC}"
    echo ""
    
    case ${1:-"basic"} in
        "basic")
            echo -e "${YELLOW}🔍 Running basic Flutter doctor...${NC}"
            flutter doctor
            ;;
        "verbose")
            echo -e "${YELLOW}🔍 Running verbose Flutter doctor...${NC}"
            flutter doctor -v
            ;;
        "version")
            echo -e "${YELLOW}📋 Flutter version information:${NC}"
            flutter --version
            echo ""
            echo -e "${YELLOW}📋 Dart version:${NC}"
            dart --version
            ;;
        "upgrade")
            echo -e "${YELLOW}⬆️ Upgrading Flutter...${NC}"
            flutter upgrade
            ;;
        "channel")
            show_channel_menu
            ;;
        "config")
            show_config_menu
            ;;
        *)
            show_doctor_menu
            ;;
    esac
}

# Show channel management menu
show_channel_menu() {
    echo -e "${CYAN}📡 Flutter Channel Management${NC}"
    echo ""
    
    echo -e "${YELLOW}Current channel:${NC}"
    flutter channel
    echo ""
    
    echo -e "${WHITE}Available actions:${NC}"
    echo -e "${GREEN}1.${NC} Switch to stable"
    echo -e "${GREEN}2.${NC} Switch to beta"
    echo -e "${GREEN}3.${NC} Switch to dev"
    echo -e "${GREEN}4.${NC} Switch to master"
    echo -e "${GREEN}5.${NC} Show all channels"
    echo ""
    read -p "Enter choice (1-5): " channel_choice
    
    case $channel_choice in
        1)
            echo -e "${YELLOW}🔄 Switching to stable channel...${NC}"
            flutter channel stable
            flutter upgrade
            ;;
        2)
            echo -e "${YELLOW}🔄 Switching to beta channel...${NC}"
            flutter channel beta
            flutter upgrade
            ;;
        3)
            echo -e "${YELLOW}🔄 Switching to dev channel...${NC}"
            flutter channel dev
            flutter upgrade
            ;;
        4)
            echo -e "${YELLOW}🔄 Switching to master channel...${NC}"
            flutter channel master
            flutter upgrade
            ;;
        5)
            echo -e "${YELLOW}📋 All available channels:${NC}"
            flutter channel
            ;;
    esac
}

# Show configuration menu
show_config_menu() {
    echo -e "${CYAN}⚙️ Flutter Configuration${NC}"
    echo ""
    
    echo -e "${YELLOW}Current configuration:${NC}"
    flutter config
    echo ""
    
    echo -e "${WHITE}Available actions:${NC}"
    echo -e "${GREEN}1.${NC} Enable analytics"
    echo -e "${GREEN}2.${NC} Disable analytics"
    echo -e "${GREEN}3.${NC} Enable crash reporting"
    echo -e "${GREEN}4.${NC} Disable crash reporting"
    echo -e "${GREEN}5.${NC} Enable web"
    echo -e "${GREEN}6.${NC} Enable desktop (all)"
    echo -e "${GREEN}7.${NC} Show all settings"
    echo ""
    read -p "Enter choice (1-7): " config_choice
    
    case $config_choice in
        1)
            flutter config --enable-analytics
            echo -e "${GREEN}✅ Analytics enabled${NC}"
            ;;
        2)
            flutter config --disable-analytics
            echo -e "${GREEN}✅ Analytics disabled${NC}"
            ;;
        3)
            flutter config --enable-crash-reporting
            echo -e "${GREEN}✅ Crash reporting enabled${NC}"
            ;;
        4)
            flutter config --disable-crash-reporting
            echo -e "${GREEN}✅ Crash reporting disabled${NC}"
            ;;
        5)
            flutter config --enable-web
            echo -e "${GREEN}✅ Web support enabled${NC}"
            ;;
        6)
            flutter config --enable-macos-desktop
            flutter config --enable-windows-desktop
            flutter config --enable-linux-desktop
            echo -e "${GREEN}✅ All desktop platforms enabled${NC}"
            ;;
        7)
            flutter config --list
            ;;
    esac
}

# Show doctor menu
show_doctor_menu() {
    echo -e "${CYAN}🏥 Flutter Doctor Menu${NC}"
    echo ""
    echo -e "${WHITE}Available actions:${NC}"
    echo -e "${GREEN}1.${NC} Basic doctor check"
    echo -e "${GREEN}2.${NC} Verbose doctor check"
    echo -e "${GREEN}3.${NC} Version information"
    echo -e "${GREEN}4.${NC} Upgrade Flutter"
    echo -e "${GREEN}5.${NC} Channel management"
    echo -e "${GREEN}6.${NC} Configuration"
    echo -e "${GREEN}7.${NC} Environment info"
    echo ""
    read -p "Enter choice (1-7): " choice
    
    case $choice in
        1) main_doctor "basic" ;;
        2) main_doctor "verbose" ;;
        3) main_doctor "version" ;;
        4) main_doctor "upgrade" ;;
        5) main_doctor "channel" ;;
        6) main_doctor "config" ;;
        7) show_environment_info ;;
    esac
}

# Show environment information
show_environment_info() {
    echo -e "${CYAN}🌍 Environment Information${NC}"
    echo ""
    
    echo -e "${YELLOW}Flutter SDK Path:${NC}"
    which flutter
    echo ""
    
    echo -e "${YELLOW}Dart SDK Path:${NC}"
    which dart
    echo ""
    
    echo -e "${YELLOW}Android SDK:${NC}"
    echo $ANDROID_HOME
    echo ""
    
    echo -e "${YELLOW}Java Version:${NC}"
    java -version 2>&1 | head -1
    echo ""
    
    echo -e "${YELLOW}Xcode (macOS only):${NC}"
    if command -v xcodebuild &> /dev/null; then
        xcodebuild -version | head -1
    else
        echo "Not available"
    fi
    echo ""
    
    echo -e "${YELLOW}Git Version:${NC}"
    git --version
    echo ""
    
    echo -e "${YELLOW}VS Code:${NC}"
    if command -v code &> /dev/null; then
        code --version | head -1
    else
        echo "Not available"
    fi
}

# Run the appropriate function based on arguments
if [ $# -eq 0 ]; then
    show_doctor_menu
else
    main_doctor "$1"
fi