#!/bin/bash

# Flutter Package Management Script
# Compatible with Flutter 3.x and latest pub.dev

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

# Show package management menu
show_pub_menu() {
    echo -e "${CYAN}📦 Flutter Package Management${NC}"
    echo ""
    echo -e "${WHITE}Dependencies:${NC}"
    echo -e "${GREEN}1.${NC} Get Dependencies"
    echo -e "${GREEN}2.${NC} Upgrade Dependencies"
    echo -e "${GREEN}3.${NC} Add Package"
    echo -e "${GREEN}4.${NC} Remove Package"
    echo -e "${GREEN}5.${NC} Show Dependency Tree"
    echo ""
    echo -e "${WHITE}Publishing:${NC}"
    echo -e "${GREEN}6.${NC} Create Package Template"
    echo -e "${GREEN}7.${NC} Dry Run Publish"
    echo -e "${GREEN}8.${NC} Publish to pub.dev"
    echo -e "${GREEN}9.${NC} Validate Package"
    echo ""
    echo -e "${WHITE}Global Packages:${NC}"
    echo -e "${GREEN}10.${NC} Activate Global Package"
    echo -e "${GREEN}11.${NC} Deactivate Global Package"
    echo -e "${GREEN}12.${NC} List Global Packages"
    echo -e "${GREEN}13.${NC} Run Global Package"
    echo ""
    echo -e "${WHITE}Cache:${NC}"
    echo -e "${GREEN}14.${NC} Repair Cache"
    echo -e "${GREEN}15.${NC} List Cache"
    echo -e "${GREEN}16.${NC} Clean Cache"
    echo ""
    read -p "Enter choice (1-16): " pub_choice
    
    case $pub_choice in
        1) get_dependencies ;;
        2) upgrade_dependencies ;;
        3) add_package ;;
        4) remove_package ;;
        5) show_dependency_tree ;;
        6) create_package_template ;;
        7) dry_run_publish ;;
        8) publish_package ;;
        9) validate_package ;;
        10) activate_global_package ;;
        11) deactivate_global_package ;;
        12) list_global_packages ;;
        13) run_global_package ;;
        14) repair_cache ;;
        15) list_cache ;;
        16) clean_cache ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Get dependencies
get_dependencies() {
    echo -e "${YELLOW}📦 Getting Flutter dependencies...${NC}"
    flutter pub get
    echo -e "${GREEN}✅ Dependencies updated${NC}"
}

# Upgrade dependencies
upgrade_dependencies() {
    echo -e "${YELLOW}⬆️ Upgrading Flutter dependencies...${NC}"
    flutter pub upgrade
    echo -e "${GREEN}✅ Dependencies upgraded${NC}"
}

# Add package
add_package() {
    read -p "Enter package name: " package_name
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}➕ Adding package: $package_name${NC}"
    flutter pub add $package_name
    echo -e "${GREEN}✅ Package added${NC}"
}

# Remove package
remove_package() {
    read -p "Enter package name to remove: " package_name
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}➖ Removing package: $package_name${NC}"
    flutter pub remove $package_name
    echo -e "${GREEN}✅ Package removed${NC}"
}

# Show dependency tree
show_dependency_tree() {
    echo -e "${YELLOW}🌳 Showing dependency tree...${NC}"
    flutter pub deps
}

# Create package template
create_package_template() {
    read -p "Enter package name: " package_name
    read -p "Enter organization (e.g., com.example): " org_name
    
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}📦 Creating package template...${NC}"
    flutter create --template=package --org=$org_name $package_name
    echo -e "${GREEN}✅ Package template created: $package_name${NC}"
}

# Dry run publish
dry_run_publish() {
    echo -e "${YELLOW}🧪 Running publish dry-run...${NC}"
    flutter pub publish --dry-run
}

# Publish package
publish_package() {
    echo -e "${RED}⚠️  This will publish your package to pub.dev!${NC}"
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🚀 Publishing package...${NC}"
        flutter pub publish
    else
        echo -e "${YELLOW}❌ Publish cancelled${NC}"
    fi
}

# Validate package
validate_package() {
    echo -e "${YELLOW}✅ Validating package...${NC}"
    dart pub publish --dry-run
}

# Activate global package
activate_global_package() {
    read -p "Enter package name to activate globally: " package_name
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}🌍 Activating global package: $package_name${NC}"
    flutter pub global activate $package_name
    echo -e "${GREEN}✅ Package activated globally${NC}"
}

# Deactivate global package
deactivate_global_package() {
    read -p "Enter package name to deactivate: " package_name
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}🌍 Deactivating global package: $package_name${NC}"
    flutter pub global deactivate $package_name
    echo -e "${GREEN}✅ Package deactivated${NC}"
}

# List global packages
list_global_packages() {
    echo -e "${YELLOW}🌍 Listing global packages...${NC}"
    flutter pub global list
}

# Run global package
run_global_package() {
    read -p "Enter package name to run: " package_name
    if [ -z "$package_name" ]; then
        echo -e "${RED}❌ Package name cannot be empty${NC}"
        return
    fi
    
    echo -e "${YELLOW}🏃 Running global package: $package_name${NC}"
    flutter pub global run $package_name
}

# Repair cache
repair_cache() {
    echo -e "${YELLOW}🔧 Repairing pub cache...${NC}"
    flutter pub cache repair
    echo -e "${GREEN}✅ Cache repaired${NC}"
}

# List cache
list_cache() {
    echo -e "${YELLOW}📋 Listing pub cache...${NC}"
    flutter pub cache list
}

# Clean cache
clean_cache() {
    echo -e "${RED}⚠️  This will clean the entire pub cache!${NC}"
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🧹 Cleaning pub cache...${NC}"
        flutter pub cache clean
        echo -e "${GREEN}✅ Cache cleaned${NC}"
    else
        echo -e "${YELLOW}❌ Cache clean cancelled${NC}"
    fi
}

# Main execution
main() {
    check_flutter_project
    
    case ${1:-"menu"} in
        "get") get_dependencies ;;
        "upgrade") upgrade_dependencies ;;
        "add") add_package ;;
        "remove") remove_package ;;
        "deps") show_dependency_tree ;;
        "create") create_package_template ;;
        "dry-run") dry_run_publish ;;
        "publish") publish_package ;;
        "validate") validate_package ;;
        "global-activate") activate_global_package ;;
        "global-deactivate") deactivate_global_package ;;
        "global-list") list_global_packages ;;
        "global-run") run_global_package ;;
        "cache-repair") repair_cache ;;
        "cache-list") list_cache ;;
        "cache-clean") clean_cache ;;
        *) show_pub_menu ;;
    esac
}

main "$@"
