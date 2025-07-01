#!/bin/bash

# iOS App Signing Script
# iOS provisioning and certificate handling with automated management

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
        echo -e "${RED}❌ Error: iOS signing is only available on macOS!${NC}"
        exit 1
    fi
}

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Error: Not in a Flutter project directory!${NC}"
        exit 1
    fi
}

# Check if iOS project exists
check_ios_project() {
    if [ ! -d "ios" ]; then
        echo -e "${RED}❌ Error: iOS project not found!${NC}"
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

# List available certificates
list_certificates() {
    echo -e "${CYAN}🔑 Available Certificates${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Development Certificates:${NC}"
    security find-identity -v -p codesigning | grep "iPhone Developer" || echo "No development certificates found"
    echo ""
    
    echo -e "${YELLOW}📋 Distribution Certificates:${NC}"
    security find-identity -v -p codesigning | grep "iPhone Distribution" || echo "No distribution certificates found"
    echo ""
}

# List provisioning profiles
list_provisioning_profiles() {
    echo -e "${CYAN}📄 Provisioning Profiles${NC}"
    echo ""
    
    local profiles_dir="$HOME/Library/MobileDevice/Provisioning Profiles"
    
    if [ ! -d "$profiles_dir" ]; then
        echo -e "${YELLOW}⚠️  No provisioning profiles directory found${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}📋 Installed Provisioning Profiles:${NC}"
    
    for profile in "$profiles_dir"/*.mobileprovision; do
        if [ -f "$profile" ]; then
            local profile_name=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Name raw -)
            local app_id=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract Entitlements.application-identifier raw -)
            local team_name=$(security cms -D -i "$profile" 2>/dev/null | plutil -extract TeamName raw -)
            
            echo -e "${GREEN}• ${profile_name}${NC}"
            echo -e "  App ID: ${app_id}"
            echo -e "  Team: ${team_name}"
            echo ""
        fi
    done
}

# Show Xcode project signing settings
show_xcode_signing() {
    echo -e "${CYAN}⚙️ Xcode Project Signing Settings${NC}"
    echo ""
    
    check_ios_project
    
    local xcodeproj_path=$(find ios -name "*.xcodeproj" | head -1)
    
    if [ -z "$xcodeproj_path" ]; then
        echo -e "${RED}❌ No Xcode project found${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}📋 Project: $(basename "$xcodeproj_path")${NC}"
    echo ""
    
    # Show current signing settings using xcodebuild
    xcodebuild -project "$xcodeproj_path" -showBuildSettings | grep -E "(CODE_SIGN|PROVISIONING|DEVELOPMENT_TEAM)" || echo "No signing settings found"
}

# Configure automatic signing
configure_automatic_signing() {
    echo -e "${CYAN}🔄 Configure Automatic Signing${NC}"
    echo ""
    
    check_ios_project
    
    local xcodeproj_path=$(find ios -name "*.xcodeproj" | head -1)
    
    if [ -z "$xcodeproj_path" ]; then
        echo -e "${RED}❌ No Xcode project found${NC}"
        return 1
    fi
    
    read -p "Enter Development Team ID: " team_id
    
    if [ -z "$team_id" ]; then
        echo -e "${RED}❌ Team ID is required${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}⚙️ Configuring automatic signing...${NC}"
    
    # Configure using xcodebuild (simplified approach)
    xcodebuild -project "$xcodeproj_path" -target Runner -configuration Debug CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM="$team_id"
    xcodebuild -project "$xcodeproj_path" -target Runner -configuration Release CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM="$team_id"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Automatic signing configured${NC}"
    else
        echo -e "${RED}❌ Failed to configure automatic signing${NC}"
    fi
}

# Configure manual signing
configure_manual_signing() {
    echo -e "${CYAN}🔧 Configure Manual Signing${NC}"
    echo ""
    
    check_ios_project
    
    local xcodeproj_path=$(find ios -name "*.xcodeproj" | head -1)
    
    if [ -z "$xcodeproj_path" ]; then
        echo -e "${RED}❌ No Xcode project found${NC}"
        return 1
    fi
    
    read -p "Enter Development Team ID: " team_id
    read -p "Enter Provisioning Profile Name (Debug): " debug_profile
    read -p "Enter Provisioning Profile Name (Release): " release_profile
    
    echo -e "${YELLOW}⚙️ Configuring manual signing...${NC}"
    
    # Configure using xcodebuild (simplified approach)
    xcodebuild -project "$xcodeproj_path" -target Runner -configuration Debug \
        CODE_SIGN_STYLE=Manual \
        DEVELOPMENT_TEAM="$team_id" \
        PROVISIONING_PROFILE_SPECIFIER="$debug_profile"
    
    xcodebuild -project "$xcodeproj_path" -target Runner -configuration Release \
        CODE_SIGN_STYLE=Manual \
        DEVELOPMENT_TEAM="$team_id" \
        PROVISIONING_PROFILE_SPECIFIER="$release_profile"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Manual signing configured${NC}"
    else
        echo -e "${RED}❌ Failed to configure manual signing${NC}"
    fi
}

# Build and sign iOS app
build_and_sign() {
    echo -e "${CYAN}🏗️ Build and Sign iOS App${NC}"
    echo ""
    
    check_flutter_project
    check_ios_project
    check_xcode
    
    echo -e "${YELLOW}Select build type:${NC}"
    echo -e "${GREEN}1.${NC} Debug build"
    echo -e "${GREEN}2.${NC} Release build"
    echo -e "${GREEN}3.${NC} Archive for App Store"
    echo ""
    read -p "Enter choice (1-3): " build_choice
    
    case $build_choice in
        1)
            echo -e "${YELLOW}🔨 Building debug iOS app...${NC}"
            flutter build ios --debug
            ;;
        2)
            echo -e "${YELLOW}🔨 Building release iOS app...${NC}"
            flutter build ios --release
            ;;
        3)
            echo -e "${YELLOW}📦 Creating archive for App Store...${NC}"
            flutter build ios --release
            
            if [ $? -eq 0 ]; then
                echo -e "${YELLOW}📦 Creating Xcode archive...${NC}"
                local xcodeproj_path=$(find ios -name "*.xcodeproj" | head -1)
                local archive_path="build/ios/archive/Runner.xcarchive"
                
                xcodebuild -project "$xcodeproj_path" -scheme Runner -configuration Release -archivePath "$archive_path" archive
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Archive created successfully!${NC}"
                    echo -e "${YELLOW}📍 Archive location: $archive_path${NC}"
                else
                    echo -e "${RED}❌ Archive creation failed${NC}"
                fi
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Export IPA
export_ipa() {
    echo -e "${CYAN}📦 Export IPA${NC}"
    echo ""
    
    local archive_path="build/ios/archive/Runner.xcarchive"
    
    if [ ! -d "$archive_path" ]; then
        echo -e "${RED}❌ No archive found!${NC}"
        echo -e "${YELLOW}💡 Create an archive first${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Select export method:${NC}"
    echo -e "${GREEN}1.${NC} Development"
    echo -e "${GREEN}2.${NC} Ad Hoc"
    echo -e "${GREEN}3.${NC} App Store"
    echo -e "${GREEN}4.${NC} Enterprise"
    echo ""
    read -p "Enter choice (1-4): " export_choice
    
    local export_method=""
    case $export_choice in
        1) export_method="development" ;;
        2) export_method="ad-hoc" ;;
        3) export_method="app-store" ;;
        4) export_method="enterprise" ;;
        *) 
            echo -e "${RED}❌ Invalid choice${NC}"
            return 1
            ;;
    esac
    
    local export_path="build/ios/ipa"
    mkdir -p "$export_path"
    
    # Create export options plist
    local export_options="build/ios/ExportOptions.plist"
    cat > "$export_options" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>$export_method</string>
</dict>
</plist>
EOF
    
    echo -e "${YELLOW}📦 Exporting IPA...${NC}"
    xcodebuild -exportArchive -archivePath "$archive_path" -exportPath "$export_path" -exportOptionsPlist "$export_options"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ IPA exported successfully!${NC}"
        echo -e "${YELLOW}📍 IPA location: $export_path${NC}"
        
        # Show IPA files
        find "$export_path" -name "*.ipa" -exec ls -lh {} \;
    else
        echo -e "${RED}❌ IPA export failed${NC}"
    fi
}

# Install certificates and profiles
install_certificate() {
    echo -e "${CYAN}🔑 Install Certificate and Provisioning Profile${NC}"
    echo ""
    
    read -p "Enter path to .p12 certificate file: " cert_path
    read -p "Enter path to .mobileprovision file: " profile_path
    
    # Install certificate
    if [ -f "$cert_path" ]; then
        echo -e "${YELLOW}🔑 Installing certificate...${NC}"
        security import "$cert_path" -k ~/Library/Keychains/login.keychain
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Certificate installed${NC}"
        else
            echo -e "${RED}❌ Certificate installation failed${NC}"
        fi
    else
        echo -e "${RED}❌ Certificate file not found: $cert_path${NC}"
    fi
    
    # Install provisioning profile
    if [ -f "$profile_path" ]; then
        echo -e "${YELLOW}📄 Installing provisioning profile...${NC}"
        local profiles_dir="$HOME/Library/MobileDevice/Provisioning Profiles"
        mkdir -p "$profiles_dir"
        cp "$profile_path" "$profiles_dir/"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Provisioning profile installed${NC}"
        else
            echo -e "${RED}❌ Provisioning profile installation failed${NC}"
        fi
    else
        echo -e "${RED}❌ Provisioning profile not found: $profile_path${NC}"
    fi
}

# Clean signing artifacts
clean_signing() {
    echo -e "${CYAN}🧹 Clean Signing Artifacts${NC}"
    echo ""
    
    echo -e "${YELLOW}🧹 Cleaning build artifacts...${NC}"
    
    # Clean Flutter build
    flutter clean
    
    # Clean iOS build
    if [ -d "ios" ]; then
        rm -rf ios/build/
        rm -rf ios/DerivedData/
        rm -rf build/ios/
    fi
    
    # Clean Xcode archives
    rm -rf ~/Library/Developer/Xcode/Archives/
    
    echo -e "${GREEN}✅ Signing artifacts cleaned${NC}"
}

# Show iOS signing menu
show_ios_signing_menu() {
    echo -e "${CYAN}🍎 iOS App Signing${NC}"
    echo ""
    echo -e "${WHITE}Information:${NC}"
    echo -e "${GREEN}1.${NC} List Certificates"
    echo -e "${GREEN}2.${NC} List Provisioning Profiles"
    echo -e "${GREEN}3.${NC} Show Xcode Signing Settings"
    echo ""
    echo -e "${WHITE}Configuration:${NC}"
    echo -e "${GREEN}4.${NC} Configure Automatic Signing"
    echo -e "${GREEN}5.${NC} Configure Manual Signing"
    echo ""
    echo -e "${WHITE}Build & Sign:${NC}"
    echo -e "${GREEN}6.${NC} Build and Sign iOS App"
    echo -e "${GREEN}7.${NC} Export IPA"
    echo ""
    echo -e "${WHITE}Tools:${NC}"
    echo -e "${GREEN}8.${NC} Install Certificate & Profile"
    echo -e "${GREEN}9.${NC} Clean Signing Artifacts"
    echo ""
    read -p "Enter choice (1-9): " ios_choice
    
    case $ios_choice in
        1) list_certificates ;;
        2) list_provisioning_profiles ;;
        3) show_xcode_signing ;;
        4) configure_automatic_signing ;;
        5) configure_manual_signing ;;
        6) build_and_sign ;;
        7) export_ipa ;;
        8) install_certificate ;;
        9) clean_signing ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    check_macos
    
    case ${1:-"menu"} in
        "list-certs") list_certificates ;;
        "list-profiles") list_provisioning_profiles ;;
        "show-settings") show_xcode_signing ;;
        "auto-sign") configure_automatic_signing ;;
        "manual-sign") configure_manual_signing ;;
        "build") build_and_sign ;;
        "export") export_ipa ;;
        "install") install_certificate ;;
        "clean") clean_signing ;;
        *) show_ios_signing_menu ;;
    esac
}

main "$@"