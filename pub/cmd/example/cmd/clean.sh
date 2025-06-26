#!/bin/bash

# Flutter Clean & Maintenance Script
# Compatible with Flutter 3.x and latest versions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Error: Not in a Flutter project directory!${NC}"
        exit 1
    fi
}

# Show clean menu
show_clean_menu() {
    echo -e "${CYAN}🧹 Flutter Clean & Maintenance${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Basic Clean (flutter clean)"
    echo -e "${GREEN}2.${NC} Deep Clean (all build artifacts)"
    echo -e "${GREEN}3.${NC} iOS Clean (Pods & workspace)"
    echo -e "${GREEN}4.${NC} Android Clean (Gradle & cache)"
    echo -e "${GREEN}5.${NC} Pub Cache Clean"
    echo -e "${GREEN}6.${NC} Full Clean (everything)"
    echo -e "${GREEN}7.${NC} Clean & Reinstall Dependencies"
    echo ""
    read -p "Enter choice (1-7): " clean_choice
    
    case $clean_choice in
        1) basic_clean ;;
        2) deep_clean ;;
        3) ios_clean ;;
        4) android_clean ;;
        5) pub_cache_clean ;;
        6) full_clean ;;
        7) clean_and_reinstall ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Basic Flutter clean
basic_clean() {
    echo -e "${YELLOW}🧹 Running basic Flutter clean...${NC}"
    flutter clean
    echo -e "${GREEN}✅ Basic clean completed${NC}"
}

# Deep clean - removes all build artifacts
deep_clean() {
    echo -e "${YELLOW}🧹 Running deep clean...${NC}"
    flutter clean
    rm -rf build/
    rm -rf .dart_tool/
    echo -e "${GREEN}✅ Deep clean completed${NC}"
}

# iOS-specific clean
ios_clean() {
    echo -e "${YELLOW}🍎 Cleaning iOS...${NC}"
    if [ -d "ios" ]; then
        cd ios
        rm -rf Pods
        rm -rf Podfile.lock
        if command -v pod >/dev/null 2>&1; then
            pod deintegrate 2>/dev/null || echo "No CocoaPods integration to remove"
            pod cache clean --all
            echo -e "${YELLOW}📦 Reinstalling CocoaPods...${NC}"
            pod install
        else
            echo -e "${YELLOW}⚠️  CocoaPods not installed, skipping pod commands${NC}"
        fi
        cd ..
        echo -e "${GREEN}✅ iOS clean completed${NC}"
    else
        echo -e "${YELLOW}⚠️  No iOS directory found${NC}"
    fi
}

# Android-specific clean
android_clean() {
    echo -e "${YELLOW}🤖 Cleaning Android...${NC}"
    if [ -d "android" ]; then
        cd android
        if [ -f "gradlew" ]; then
            ./gradlew clean
        fi
        rm -rf .gradle
        rm -rf build/
        cd ..
        echo -e "${GREEN}✅ Android clean completed${NC}"
    else
        echo -e "${YELLOW}⚠️  No Android directory found${NC}"
    fi
}

# Pub cache clean
pub_cache_clean() {
    echo -e "${YELLOW}📦 Cleaning Flutter pub cache...${NC}"
    flutter pub cache repair
    echo -e "${GREEN}✅ Pub cache cleaned${NC}"
}

# Full clean - everything
full_clean() {
    echo -e "${YELLOW}🧹 Running full clean (this may take a while)...${NC}"
    
    # Flutter clean
    flutter clean
    
    # Remove build artifacts
    rm -rf build/
    rm -rf .dart_tool/
    
    # iOS clean
    if [ -d "ios" ]; then
        echo -e "${YELLOW}🍎 Cleaning iOS...${NC}"
        cd ios
        rm -rf Pods
        rm -rf Podfile.lock
        rm -rf build/
        cd ..
    fi
    
    # Android clean
    if [ -d "android" ]; then
        echo -e "${YELLOW}🤖 Cleaning Android...${NC}"
        cd android
        if [ -f "gradlew" ]; then
            ./gradlew clean
        fi
        rm -rf .gradle
        rm -rf build/
        cd ..
    fi
    
    # Web clean
    if [ -d "build/web" ]; then
        rm -rf build/web
    fi
    
    # Pub cache
    flutter pub cache repair
    
    echo -e "${GREEN}✅ Full clean completed${NC}"
}

# Clean and reinstall dependencies
clean_and_reinstall() {
    echo -e "${YELLOW}🔄 Cleaning and reinstalling dependencies...${NC}"
    
    # Full clean first
    full_clean
    
    # Get dependencies
    echo -e "${YELLOW}📦 Getting Flutter dependencies...${NC}"
    flutter pub get
    
    # iOS pods if directory exists
    if [ -d "ios" ] && command -v pod >/dev/null 2>&1; then
        echo -e "${YELLOW}🍎 Installing iOS pods...${NC}"
        cd ios
        pod install
        cd ..
    fi
    
    echo -e "${GREEN}✅ Clean and reinstall completed${NC}"
}

# Main execution
main() {
    check_flutter_project
    
    case ${1:-"menu"} in
        "basic") basic_clean ;;
        "deep") deep_clean ;;
        "ios") ios_clean ;;
        "android") android_clean ;;
        "pub") pub_cache_clean ;;
        "full") full_clean ;;
        "reinstall") clean_and_reinstall ;;
        *) show_clean_menu ;;
    esac
}

main "$@"