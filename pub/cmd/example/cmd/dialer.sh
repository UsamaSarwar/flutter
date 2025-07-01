#!/bin/bash

# CMD Dialer - Interactive Flutter Command Interface
# Modern terminal-based dialer interface with categorized navigation

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clear screen function
clear_screen() {
    clear
}

# Show header
show_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                       ${WHITE}🎯 Flutter CMD Dialer${CYAN}                      ║${NC}"
    echo -e "${CYAN}║                   ${YELLOW}Interactive Command Interface${CYAN}                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Show main menu
show_main_menu() {
    clear_screen
    show_header
    
    echo -e "${WHITE}📋 Available Script Categories:${NC}"
    echo ""
    echo -e "${GREEN} 1.${NC} ${BLUE}🏥 Environment & Doctor${NC}     - Check Flutter setup and environment"
    echo -e "${GREEN} 2.${NC} ${BLUE}🏃 Run & Debug${NC}              - Run Flutter apps with various options"
    echo -e "${GREEN} 3.${NC} ${BLUE}🔨 Build & Deploy${NC}           - Build apps for different platforms"
    echo -e "${GREEN} 4.${NC} ${BLUE}📦 Package Management${NC}       - Manage dependencies and packages"
    echo -e "${GREEN} 5.${NC} ${BLUE}🧹 Clean & Maintenance${NC}      - Clean project and cache"
    echo -e "${GREEN} 6.${NC} ${BLUE}🔐 App Signing${NC}              - Android and iOS signing tools"
    echo -e "${GREEN} 7.${NC} ${BLUE}🧪 Testing & Analysis${NC}       - Run tests and performance analysis"
    echo -e "${GREEN} 8.${NC} ${BLUE}🛠️  Platform Utilities${NC}       - Platform-specific tools"
    echo -e "${GREEN} 9.${NC} ${BLUE}⚙️  Setup & Configuration${NC}    - Project setup and configuration"
    echo -e "${GREEN}10.${NC} ${BLUE}☁️  Cloud & Deployment${NC}       - Firebase and cloud deployment"
    echo ""
    echo -e "${MAGENTA}0.${NC} Exit"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice (0-10): ${NC}")" main_choice
    
    case $main_choice in
        1) show_environment_menu ;;
        2) show_run_menu ;;
        3) show_build_menu ;;
        4) show_package_menu ;;
        5) show_clean_menu ;;
        6) show_signing_menu ;;
        7) show_testing_menu ;;
        8) show_platform_menu ;;
        9) show_setup_menu ;;
        10) show_cloud_menu ;;
        0) 
            echo -e "${GREEN}👋 Goodbye!${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
            read -p "Press Enter to continue..."
            show_main_menu
            ;;
    esac
}

# Environment & Doctor Menu
show_environment_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🏥 Environment & Doctor${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Basic Doctor Check"
    echo -e "${GREEN}2.${NC} Verbose Doctor Check"
    echo -e "${GREEN}3.${NC} Flutter Version Info"
    echo -e "${GREEN}4.${NC} Upgrade Flutter"
    echo -e "${GREEN}5.${NC} Channel Management"
    echo -e "${GREEN}6.${NC} Configuration Settings"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" env_choice
    
    case $env_choice in
        1) bash "$SCRIPT_DIR/doctor.sh" basic ;;
        2) bash "$SCRIPT_DIR/doctor.sh" verbose ;;
        3) bash "$SCRIPT_DIR/doctor.sh" version ;;
        4) bash "$SCRIPT_DIR/doctor.sh" upgrade ;;
        5) bash "$SCRIPT_DIR/doctor.sh" channel ;;
        6) bash "$SCRIPT_DIR/doctor.sh" config ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_environment_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_environment_menu
}

# Run & Debug Menu
show_run_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🏃 Run & Debug${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Run in Debug Mode"
    echo -e "${GREEN}2.${NC} Run in Release Mode"
    echo -e "${GREEN}3.${NC} Run in Profile Mode"
    echo -e "${GREEN}4.${NC} Select Device and Run"
    echo -e "${GREEN}5.${NC} Run Web App"
    echo -e "${GREEN}6.${NC} Run with Flavor"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" run_choice
    
    case $run_choice in
        1) bash "$SCRIPT_DIR/run.sh" debug ;;
        2) bash "$SCRIPT_DIR/run.sh" release ;;
        3) bash "$SCRIPT_DIR/run.sh" profile ;;
        4) bash "$SCRIPT_DIR/run.sh" device ;;
        5) bash "$SCRIPT_DIR/run.sh" web ;;
        6) bash "$SCRIPT_DIR/run.sh" flavor ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_run_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_run_menu
}

# Build & Deploy Menu
show_build_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🔨 Build & Deploy${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Build Android APK"
    echo -e "${GREEN}2.${NC} Build Android App Bundle"
    echo -e "${GREEN}3.${NC} Build iOS App"
    echo -e "${GREEN}4.${NC} Build Web App"
    echo -e "${GREEN}5.${NC} Build macOS App"
    echo -e "${GREEN}6.${NC} Build Windows App"
    echo -e "${GREEN}7.${NC} Build Linux App"
    echo -e "${GREEN}8.${NC} Build All Platforms"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" build_choice
    
    case $build_choice in
        1) bash "$SCRIPT_DIR/build.sh" android-apk ;;
        2) bash "$SCRIPT_DIR/build.sh" android-bundle ;;
        3) bash "$SCRIPT_DIR/build.sh" ios ;;
        4) bash "$SCRIPT_DIR/build.sh" web ;;
        5) bash "$SCRIPT_DIR/build.sh" macos ;;
        6) bash "$SCRIPT_DIR/build.sh" windows ;;
        7) bash "$SCRIPT_DIR/build.sh" linux ;;
        8) bash "$SCRIPT_DIR/build.sh" all ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_build_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_build_menu
}

# Package Management Menu
show_package_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}📦 Package Management${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Get Dependencies"
    echo -e "${GREEN}2.${NC} Upgrade Dependencies"
    echo -e "${GREEN}3.${NC} Add Package"
    echo -e "${GREEN}4.${NC} Remove Package"
    echo -e "${GREEN}5.${NC} Show Dependency Tree"
    echo -e "${GREEN}6.${NC} Global Package Management"
    echo -e "${GREEN}7.${NC} Cache Operations"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" package_choice
    
    case $package_choice in
        1) bash "$SCRIPT_DIR/pub.sh" get ;;
        2) bash "$SCRIPT_DIR/pub.sh" upgrade ;;
        3) bash "$SCRIPT_DIR/pub.sh" add ;;
        4) bash "$SCRIPT_DIR/pub.sh" remove ;;
        5) bash "$SCRIPT_DIR/pub.sh" deps ;;
        6) bash "$SCRIPT_DIR/pub.sh" global ;;
        7) bash "$SCRIPT_DIR/pub.sh" cache ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_package_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_package_menu
}

# Clean & Maintenance Menu
show_clean_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🧹 Clean & Maintenance${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Basic Clean"
    echo -e "${GREEN}2.${NC} Deep Clean"
    echo -e "${GREEN}3.${NC} iOS Clean"
    echo -e "${GREEN}4.${NC} Android Clean"
    echo -e "${GREEN}5.${NC} Pub Cache Clean"
    echo -e "${GREEN}6.${NC} Full Clean"
    echo -e "${GREEN}7.${NC} Clean & Reinstall"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" clean_choice
    
    case $clean_choice in
        1) bash "$SCRIPT_DIR/clean.sh" basic ;;
        2) bash "$SCRIPT_DIR/clean.sh" deep ;;
        3) bash "$SCRIPT_DIR/clean.sh" ios ;;
        4) bash "$SCRIPT_DIR/clean.sh" android ;;
        5) bash "$SCRIPT_DIR/clean.sh" cache ;;
        6) bash "$SCRIPT_DIR/clean.sh" full ;;
        7) bash "$SCRIPT_DIR/clean.sh" reinstall ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_clean_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_clean_menu
}

# App Signing Menu
show_signing_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🔐 App Signing${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Android Signing"
    echo -e "${GREEN}2.${NC} iOS Signing"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" signing_choice
    
    case $signing_choice in
        1) bash "$SCRIPT_DIR/android_signing.sh" ;;
        2) bash "$SCRIPT_DIR/ios_signing.sh" ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_signing_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_signing_menu
}

# Testing & Analysis Menu
show_testing_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🧪 Testing & Analysis${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Run Unit Tests"
    echo -e "${GREEN}2.${NC} Run Widget Tests"
    echo -e "${GREEN}3.${NC} Run Integration Tests"
    echo -e "${GREEN}4.${NC} Run All Tests"
    echo -e "${GREEN}5.${NC} Test with Coverage"
    echo -e "${GREEN}6.${NC} Performance Testing"
    echo -e "${GREEN}7.${NC} Continuous Testing"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" testing_choice
    
    case $testing_choice in
        1) bash "$SCRIPT_DIR/testing.sh" unit ;;
        2) bash "$SCRIPT_DIR/testing.sh" widget ;;
        3) bash "$SCRIPT_DIR/testing.sh" integration ;;
        4) bash "$SCRIPT_DIR/testing.sh" all ;;
        5) bash "$SCRIPT_DIR/testing.sh" coverage ;;
        6) bash "$SCRIPT_DIR/performance.sh" ;;
        7) bash "$SCRIPT_DIR/testing.sh" watch ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_testing_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_testing_menu
}

# Platform Utilities Menu
show_platform_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}🛠️ Platform Utilities${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} macOS Utilities"
    echo -e "${GREEN}2.${NC} Windows Utilities"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" platform_choice
    
    case $platform_choice in
        1) bash "$SCRIPT_DIR/macos_utils.sh" ;;
        2) bash "$SCRIPT_DIR/windows_utils.sh" ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_platform_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_platform_menu
}

# Setup & Configuration Menu
show_setup_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}⚙️ Setup & Configuration${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} New Project Setup"
    echo -e "${GREEN}2.${NC} Environment Configuration"
    echo -e "${GREEN}3.${NC} Platform Setup"
    echo -e "${GREEN}4.${NC} Development Tools Setup"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" setup_choice
    
    case $setup_choice in
        1) bash "$SCRIPT_DIR/setup.sh" project ;;
        2) bash "$SCRIPT_DIR/setup.sh" environment ;;
        3) bash "$SCRIPT_DIR/setup.sh" platform ;;
        4) bash "$SCRIPT_DIR/setup.sh" tools ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_setup_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_setup_menu
}

# Cloud & Deployment Menu
show_cloud_menu() {
    clear_screen
    show_header
    
    echo -e "${BLUE}☁️ Cloud & Deployment${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Firebase Deployment"
    echo -e "${GREEN}2.${NC} Google Cloud Storage CORS"
    echo ""
    echo -e "${MAGENTA}0.${NC} Back to Main Menu"
    echo ""
    read -p "$(echo -e "${YELLOW}Enter your choice: ${NC}")" cloud_choice
    
    case $cloud_choice in
        1) bash "$SCRIPT_DIR/deploy.sh" ;;
        2) bash "$SCRIPT_DIR/cors_gcs.sh" ;;
        0) show_main_menu ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            read -p "Press Enter to continue..."
            show_cloud_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_cloud_menu
}

# Show welcome message
show_welcome() {
    clear_screen
    show_header
    
    echo -e "${GREEN}Welcome to Flutter CMD Dialer!${NC}"
    echo ""
    echo -e "${YELLOW}This interactive interface helps you navigate through${NC}"
    echo -e "${YELLOW}various Flutter development scripts and tools.${NC}"
    echo ""
    echo -e "${CYAN}Choose from categorized menus to access:${NC}"
    echo -e "${WHITE}• Environment and diagnostic tools${NC}"
    echo -e "${WHITE}• Build and deployment scripts${NC}"
    echo -e "${WHITE}• Testing and performance analysis${NC}"
    echo -e "${WHITE}• Platform-specific utilities${NC}"
    echo -e "${WHITE}• And much more!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

# Main execution
main() {
    # Show welcome message if no arguments
    if [ $# -eq 0 ]; then
        show_welcome
        show_main_menu
    else
        # Direct script execution with arguments
        case $1 in
            "environment") show_environment_menu ;;
            "run") show_run_menu ;;
            "build") show_build_menu ;;
            "package") show_package_menu ;;
            "clean") show_clean_menu ;;
            "signing") show_signing_menu ;;
            "testing") show_testing_menu ;;
            "platform") show_platform_menu ;;
            "setup") show_setup_menu ;;
            "cloud") show_cloud_menu ;;
            *) show_main_menu ;;
        esac
    fi
}

# Trap Ctrl+C to show exit message
trap 'echo -e "\n${GREEN}👋 Goodbye!${NC}"; exit 0' INT

main "$@"