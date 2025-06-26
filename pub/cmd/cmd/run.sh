#!/bin/bash

# Flutter Run & Debug Script
# Compatible with Flutter 3.x and latest versions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Main run function
main_run() {
    echo -e "${CYAN}🏃 Flutter Run & Debug${NC}"
    echo ""
    
    case ${1:-"menu"} in
        "debug")
            echo -e "${YELLOW}🐛 Running in debug mode...${NC}"
            flutter run --debug
            ;;
        "release")
            echo -e "${YELLOW}🚀 Running in release mode...${NC}"
            flutter run --release
            ;;
        "profile")
            echo -e "${YELLOW}📊 Running in profile mode...${NC}"
            flutter run --profile
            ;;
        "device")
            select_device_and_run
            ;;
        "web")
            run_web_app
            ;;
        "flavor")
            run_with_flavor
            ;;
        "restart")
            echo -e "${YELLOW}🔄 Hot restart...${NC}"
            # This would typically be used within a running Flutter app
            echo "Use 'R' key in running Flutter app for hot restart"
            ;;
        *)
            show_run_menu
            ;;
    esac
}

# Select device and run
select_device_and_run() {
    echo -e "${CYAN}📱 Device Selection${NC}"
    echo ""
    
    echo -e "${YELLOW}🔍 Available devices:${NC}"
    flutter devices
    echo ""
    
    read -p "Enter device ID (or press Enter for default): " device_id
    
    if [ -z "$device_id" ]; then
        flutter run
    else
        flutter run -d "$device_id"
    fi
}

# Run web app
run_web_app() {
    echo -e "${CYAN}🌐 Running Web App${NC}"
    echo ""
    
    echo -e "${YELLOW}Select web runner:${NC}"
    echo -e "${GREEN}1.${NC} Chrome (default)"
    echo -e "${GREEN}2.${NC} Web server"
    echo -e "${GREEN}3.${NC} Chrome with hot reload"
    echo -e "${GREEN}4.${NC} Chrome with debug tools"
    echo ""
    read -p "Enter choice (1-4): " web_choice
    
    case $web_choice in
        1)
            flutter run -d chrome
            ;;
        2)
            flutter run -d web-server --web-port=8080
            echo -e "${GREEN}🌐 App running at: http://localhost:8080${NC}"
            ;;
        3)
            flutter run -d chrome --hot
            ;;
        4)
            flutter run -d chrome --web-enable-devtools-remote-debugging
            ;;
        *)
            flutter run -d chrome
            ;;
    esac
}

# Run with flavor
run_with_flavor() {
    echo -e "${CYAN}🎯 Running with Flavor${NC}"
    echo ""
    
    echo -e "${YELLOW}Select flavor:${NC}"
    echo -e "${GREEN}1.${NC} Development"
    echo -e "${GREEN}2.${NC} Staging"
    echo -e "${GREEN}3.${NC} Production"
    echo -e "${GREEN}4.${NC} Custom"
    echo ""
    read -p "Enter choice (1-4): " flavor_choice
    
    case $flavor_choice in
        1)
            flutter run --flavor dev --dart-define=ENV=development
            ;;
        2)
            flutter run --flavor staging --dart-define=ENV=staging
            ;;
        3)
            flutter run --flavor prod --dart-define=ENV=production
            ;;
        4)
            read -p "Enter custom flavor name: " custom_flavor
            flutter run --flavor "$custom_flavor"
            ;;
    esac
}

# Run with specific architecture
run_with_architecture() {
    echo -e "${CYAN}🏗️ Architecture Selection${NC}"
    echo ""
    
    echo -e "${YELLOW}Select architecture:${NC}"
    echo -e "${GREEN}1.${NC} ARM64 (default)"
    echo -e "${GREEN}2.${NC} x86_64"
    echo -e "${GREEN}3.${NC} Universal"
    echo ""
    read -p "Enter choice (1-3): " arch_choice
    
    case $arch_choice in
        1)
            flutter run --ios-simulator-device-model "iPhone 14 Pro"
            ;;
        2)
            flutter run --ios-simulator-device-model "iPhone 14 Pro" --debug-port=0
            ;;
        3)
            flutter run --target-platform android-arm,android-arm64,android-x64
            ;;
    esac
}

# Run with custom options
run_with_options() {
    echo -e "${CYAN}⚙️ Custom Run Options${NC}"
    echo ""
    
    local options=""
    
    read -p "Enable hot reload? (y/n): " hot_reload
    if [[ $hot_reload =~ ^[Yy]$ ]]; then
        options="$options --hot"
    fi
    
    read -p "Enable observatory? (y/n): " observatory
    if [[ $observatory =~ ^[Yy]$ ]]; then
        read -p "Observatory port (default 8080): " obs_port
        obs_port=${obs_port:-8080}
        options="$options --observatory-port=$obs_port"
    fi
    
    read -p "Enable verbose logging? (y/n): " verbose
    if [[ $verbose =~ ^[Yy]$ ]]; then
        options="$options -v"
    fi
    
    read -p "Target file (default lib/main.dart): " target
    target=${target:-lib/main.dart}
    options="$options --target=$target"
    
    echo -e "${YELLOW}🚀 Running with options: $options${NC}"
    flutter run $options
}

# Show performance overlay
run_with_performance() {
    echo -e "${CYAN}📊 Performance Monitoring${NC}"
    echo ""
    
    echo -e "${YELLOW}Select performance mode:${NC}"
    echo -e "${GREEN}1.${NC} Profile mode with performance overlay"
    echo -e "${GREEN}2.${NC} Debug with performance overlay"
    echo -e "${GREEN}3.${NC} Trace startup performance"
    echo -e "${GREEN}4.${NC} Memory profiling"
    echo ""
    read -p "Enter choice (1-4): " perf_choice
    
    case $perf_choice in
        1)
            flutter run --profile --enable-software-rendering
            ;;
        2)
            flutter run --debug --enable-software-rendering
            ;;
        3)
            flutter run --profile --trace-startup
            ;;
        4)
            flutter run --profile --memory-profile
            ;;
    esac
}

# Show run menu
show_run_menu() {
    echo -e "${CYAN}🏃 Flutter Run Menu${NC}"
    echo ""
    echo -e "${WHITE}Available actions:${NC}"
    echo -e "${GREEN}1.${NC} 🐛 Run debug mode"
    echo -e "${GREEN}2.${NC} 🚀 Run release mode"
    echo -e "${GREEN}3.${NC} 📊 Run profile mode"
    echo -e "${GREEN}4.${NC} 📱 Select device and run"
    echo -e "${GREEN}5.${NC} 🌐 Run web app"
    echo -e "${GREEN}6.${NC} 🎯 Run with flavor"
    echo -e "${GREEN}7.${NC} 🏗️  Run with architecture selection"
    echo -e "${GREEN}8.${NC} ⚙️  Run with custom options"
    echo -e "${GREEN}9.${NC} 📊 Run with performance monitoring"
    echo -e "${GREEN}10.${NC} 🔄 Show hot reload tips"
    echo ""
    read -p "Enter choice (1-10): " choice
    
    case $choice in
        1) main_run "debug" ;;
        2) main_run "release" ;;
        3) main_run "profile" ;;
        4) main_run "device" ;;
        5) main_run "web" ;;
        6) main_run "flavor" ;;
        7) run_with_architecture ;;
        8) run_with_options ;;
        9) run_with_performance ;;
        10) show_hot_reload_tips ;;
    esac
}

# Show hot reload tips
show_hot_reload_tips() {
    echo -e "${CYAN}🔄 Hot Reload Tips${NC}"
    echo ""
    echo -e "${YELLOW}While your app is running, you can use:${NC}"
    echo -e "${GREEN}r${NC} - Hot reload (reloads changed code)"
    echo -e "${GREEN}R${NC} - Hot restart (restarts the app)"
    echo -e "${GREEN}h${NC} - Help (show all commands)"
    echo -e "${GREEN}d${NC} - Detach (keep app running, stop debugging)"
    echo -e "${GREEN}c${NC} - Clear the screen"
    echo -e "${GREEN}q${NC} - Quit the debugging session"
    echo ""
    echo -e "${YELLOW}For better performance:${NC}"
    echo -e "${WHITE}• Use hot reload for UI changes${NC}"
    echo -e "${WHITE}• Use hot restart for logic changes${NC}"
    echo -e "${WHITE}• Use profile mode for performance testing${NC}"
    echo -e "${WHITE}• Use release mode for final testing${NC}"
}

# Run the appropriate function based on arguments
if [ $# -eq 0 ]; then
    show_run_menu
else
    main_run "$1"
fi