#!/bin/bash

# Flutter Build Script - Modern & Interactive
# Compatible with Flutter 3.x and latest build tools

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Ensure export directory exists
setup_export_dir() {
    mkdir -p export
    echo -e "${GREEN}📁 Export directory ready: $(pwd)/export${NC}"
}

# Build Android APK
build_android_apk() {
    echo -e "${CYAN}📱 Building Android APK${NC}"
    echo ""
    
    echo -e "${YELLOW}Select build type:${NC}"
    echo -e "${GREEN}1.${NC} Release APK"
    echo -e "${GREEN}2.${NC} Debug APK"
    echo -e "${GREEN}3.${NC} Profile APK"
    echo ""
    read -p "Enter choice (1-3): " build_choice
    
    setup_export_dir
    
    case $build_choice in
        1)
            echo -e "${YELLOW}🔨 Building release APK...${NC}"
            flutter build apk --release
            if [ $? -eq 0 ]; then
                cp build/app/outputs/flutter-apk/app-release.apk export/app-release.apk
                echo -e "${GREEN}✅ APK built successfully!${NC}"
                echo -e "${GREEN}📱 Location: export/app-release.apk${NC}"
                show_apk_info "export/app-release.apk"
            fi
            ;;
        2)
            echo -e "${YELLOW}🔨 Building debug APK...${NC}"
            flutter build apk --debug
            if [ $? -eq 0 ]; then
                cp build/app/outputs/flutter-apk/app-debug.apk export/app-debug.apk
                echo -e "${GREEN}✅ Debug APK built successfully!${NC}"
                echo -e "${GREEN}📱 Location: export/app-debug.apk${NC}"
            fi
            ;;
        3)
            echo -e "${YELLOW}🔨 Building profile APK...${NC}"
            flutter build apk --profile
            if [ $? -eq 0 ]; then
                cp build/app/outputs/flutter-apk/app-profile.apk export/app-profile.apk
                echo -e "${GREEN}✅ Profile APK built successfully!${NC}"
                echo -e "${GREEN}📱 Location: export/app-profile.apk${NC}"
            fi
            ;;
    esac
}

# Build Android App Bundle
build_android_bundle() {
    echo -e "${CYAN}📦 Building Android App Bundle${NC}"
    echo ""
    
    setup_export_dir
    
    echo -e "${YELLOW}🔨 Building release App Bundle...${NC}"
    flutter build appbundle --release
    
    if [ $? -eq 0 ]; then
        cp build/app/outputs/bundle/release/app-release.aab export/app-release.aab
        echo -e "${GREEN}✅ App Bundle built successfully!${NC}"
        echo -e "${GREEN}📦 Location: export/app-release.aab${NC}"
        show_aab_info "export/app-release.aab"

        # Copy debug symbols if available
        if [ -f "build/app/outputs/bundle/release/debug-symbols.zip" ]; then
            cp build/app/outputs/bundle/release/debug-symbols.zip export/debug_symbols.zip
            echo -e "${GREEN}✅ Debug symbols exported to: export/debug_symbols.zip${NC}"
        elif [ -d "build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib" ]; then
            echo -e "${YELLOW}🔨 Zipping native libs for debug symbols...${NC}"
            (cd build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out && zip -r debug-symbols.zip lib)
            cp build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/debug-symbols.zip export/debug_symbols.zip
            echo -e "${GREEN}✅ Debug symbols created and exported to: export/debug_symbols.zip${NC}"
        fi
    else
        echo -e "${RED}❌ App Bundle build failed${NC}"
    fi
}

# Build iOS
build_ios() {
    echo -e "${CYAN}🍎 Building iOS App${NC}"
    echo ""
    
    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ iOS builds require macOS${NC}"
        return
    fi
    
    echo -e "${YELLOW}Select build type:${NC}"
    echo -e "${GREEN}1.${NC} Release build"
    echo -e "${GREEN}2.${NC} Debug build"
    echo -e "${GREEN}3.${NC} Profile build"
    echo -e "${GREEN}4.${NC} Archive for App Store"
    echo ""
    read -p "Enter choice (1-4): " ios_choice
    
    setup_export_dir
    
    case $ios_choice in
        1)
            echo -e "${YELLOW}🔨 Building iOS release...${NC}"
            flutter build ios --release --no-codesign
            ;;
        2)
            echo -e "${YELLOW}🔨 Building iOS debug...${NC}"
            flutter build ios --debug --no-codesign
            ;;
        3)
            echo -e "${YELLOW}🔨 Building iOS profile...${NC}"
            flutter build ios --profile --no-codesign
            ;;
        4)
            echo -e "${YELLOW}🔨 Creating iOS archive...${NC}"
            flutter build ios --release
            # Additional archiving steps would go here
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ iOS build completed!${NC}"
        if [ -d "build/ios/iphoneos/Runner.app" ]; then
            cp -r build/ios/iphoneos/Runner.app export/Runner.app
            echo -e "${GREEN}🍎 App copied to: export/Runner.app${NC}"
        fi
    else
        echo -e "${RED}❌ iOS build failed${NC}"
    fi
}

# Build Web
build_web() {
    echo -e "${CYAN}🌐 Building Web App${NC}"
    echo ""
    
    echo -e "${YELLOW}Select web renderer:${NC}"
    echo -e "${GREEN}1.${NC} Auto (default)"
    echo -e "${GREEN}2.${NC} HTML renderer"
    echo -e "${GREEN}3.${NC} CanvasKit renderer"
    echo ""
    read -p "Enter choice (1-3): " web_choice
    
    setup_export_dir
    
    case $web_choice in
        1)
            echo -e "${YELLOW}🔨 Building web with auto renderer...${NC}"
            flutter build web --release
            ;;
        2)
            echo -e "${YELLOW}🔨 Building web with HTML renderer...${NC}"
            flutter build web --release --web-renderer html
            ;;
        3)
            echo -e "${YELLOW}🔨 Building web with CanvasKit renderer...${NC}"
            flutter build web --release --web-renderer canvaskit
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        cp -r build/web/* export/
        echo -e "${GREEN}✅ Web build completed!${NC}"
        echo -e "${GREEN}🌐 Files copied to: export/${NC}"
        show_web_info
    else
        echo -e "${RED}❌ Web build failed${NC}"
    fi
}

# Build macOS
build_macos() {
    echo -e "${CYAN}💻 Building macOS App${NC}"
    echo ""
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ macOS builds require macOS${NC}"
        return
    fi
    
    setup_export_dir
    
    echo -e "${YELLOW}🔨 Building macOS release...${NC}"
    flutter build macos --release
    
    if [ $? -eq 0 ]; then
        cp -r build/macos/Build/Products/Release/Runner.app export/Runner.app
        echo -e "${GREEN}✅ macOS build completed!${NC}"
        echo -e "${GREEN}💻 App copied to: export/Runner.app${NC}"
    else
        echo -e "${RED}❌ macOS build failed${NC}"
    fi
}

# Build Windows
build_windows() {
    echo -e "${CYAN}🪟 Building Windows App${NC}"
    echo ""
    
    setup_export_dir
    
    echo -e "${YELLOW}🔨 Building Windows release...${NC}"
    flutter build windows --release
    
    if [ $? -eq 0 ]; then
        mkdir -p export/windows
        cp -r build/windows/runner/Release/* export/windows/
        echo -e "${GREEN}✅ Windows build completed!${NC}"
        echo -e "${GREEN}🪟 Files copied to: export/windows/${NC}"
    else
        echo -e "${RED}❌ Windows build failed${NC}"
    fi
}

# Build Linux
build_linux() {
    echo -e "${CYAN}🐧 Building Linux App${NC}"
    echo ""
    
    setup_export_dir
    
    echo -e "${YELLOW}🔨 Building Linux release...${NC}"
    flutter build linux --release
    
    if [ $? -eq 0 ]; then
        mkdir -p export/linux
        cp -r build/linux/release/bundle/* export/linux/
        echo -e "${GREEN}✅ Linux build completed!${NC}"
        echo -e "${GREEN}🐧 Files copied to: export/linux/${NC}"
    else
        echo -e "${RED}❌ Linux build failed${NC}"
    fi
}

# Build all platforms
build_all() {
    echo -e "${CYAN}🎯 Building for All Platforms${NC}"
    echo ""
    
    setup_export_dir
    
    # Clean first
    echo -e "${YELLOW}🧹 Cleaning project...${NC}"
    flutter clean
    flutter pub get
    
    # Build each platform
    echo -e "${BLUE}=== Building Android APK ===${NC}"
    flutter build apk --release && cp build/app/outputs/flutter-apk/app-release.apk export/
    
    echo -e "${BLUE}=== Building Android App Bundle ===${NC}"
    flutter build appbundle --release && cp build/app/outputs/bundle/release/app-release.aab export/
    
    echo -e "${BLUE}=== Building Web ===${NC}"
    flutter build web --release && cp -r build/web export/web
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}=== Building iOS ===${NC}"
        flutter build ios --release --no-codesign && cp -r build/ios/iphoneos/Runner.app export/ios-Runner.app
        
        echo -e "${BLUE}=== Building macOS ===${NC}"
        flutter build macos --release && cp -r build/macos/Build/Products/Release/Runner.app export/macos-Runner.app
    fi
    
    echo -e "${BLUE}=== Building Windows ===${NC}"
    flutter build windows --release && mkdir -p export/windows && cp -r build/windows/runner/Release/* export/windows/
    
    echo -e "${BLUE}=== Building Linux ===${NC}"
    flutter build linux --release && mkdir -p export/linux && cp -r build/linux/release/bundle/* export/linux/
    
    echo -e "${GREEN}🎉 All builds completed!${NC}"
    show_build_summary
}

# Show APK info
show_apk_info() {
    local apk_file="$1"
    if [ -f "$apk_file" ]; then
        local size=$(du -h "$apk_file" | cut -f1)
        echo -e "${CYAN}📊 APK Information:${NC}"
        echo -e "${WHITE}• Size: $size${NC}"
        
        # Show APK contents if aapt is available
        if command -v aapt &> /dev/null; then
            echo -e "${WHITE}• Package name: $(aapt dump badging "$apk_file" | grep package | cut -d"'" -f2)${NC}"
            echo -e "${WHITE}• Version: $(aapt dump badging "$apk_file" | grep versionName | cut -d"'" -f6)${NC}"
        fi
    fi
}

# Show AAB info
show_aab_info() {
    local aab_file="$1"
    if [ -f "$aab_file" ]; then
        local size=$(du -h "$aab_file" | cut -f1)
        echo -e "${CYAN}📊 App Bundle Information:${NC}"
        echo -e "${WHITE}• Size: $size${NC}"
        echo -e "${YELLOW}💡 Upload this to Google Play Console${NC}"
    fi
}

# Show web build info
show_web_info() {
    if [ -d "export" ]; then
        local size=$(du -sh export | cut -f1)
        echo -e "${CYAN}📊 Web Build Information:${NC}"
        echo -e "${WHITE}• Total size: $size${NC}"
        echo -e "${WHITE}• Main files: index.html, main.dart.js${NC}"
        echo -e "${YELLOW}💡 Deploy the export/ folder to your web server${NC}"
    fi
}

# Show build summary
show_build_summary() {
    echo -e "${CYAN}📋 Build Summary${NC}"
    echo ""
    
    if [ -d "export" ]; then
        echo -e "${WHITE}Built files in export/:${NC}"
        ls -la export/
        echo ""
        
        local total_size=$(du -sh export | cut -f1)
        echo -e "${GREEN}📊 Total export size: $total_size${NC}"
    fi
}

# Main build function
main_build() {
    case ${1:-"menu"} in
        "android-apk") build_android_apk ;;
        "android-bundle") build_android_bundle ;;
        "ios") build_ios ;;
        "web") build_web ;;
        "macos") build_macos ;;
        "windows") build_windows ;;
        "linux") build_linux ;;
        "all") build_all ;;
        *) show_build_menu ;;
    esac
}

# Show build menu
show_build_menu() {
    echo -e "${CYAN}🔨 Flutter Build Menu${NC}"
    echo ""
    echo -e "${WHITE}Available platforms:${NC}"
    echo -e "${GREEN}1.${NC} 📱 Android APK"
    echo -e "${GREEN}2.${NC} 📦 Android App Bundle"
    echo -e "${GREEN}3.${NC} 🍎 iOS"
    echo -e "${GREEN}4.${NC} 🌐 Web"
    echo -e "${GREEN}5.${NC} 💻 macOS"
    echo -e "${GREEN}6.${NC} 🪟 Windows"
    echo -e "${GREEN}7.${NC} 🐧 Linux"
    echo -e "${GREEN}8.${NC} 🎯 All platforms"
    echo -e "${GREEN}9.${NC} 🧹 Clean and rebuild"
    echo ""
    read -p "Enter choice (1-9): " choice
    
    case $choice in
        1) build_android_apk ;;
        2) build_android_bundle ;;
        3) build_ios ;;
        4) build_web ;;
        5) build_macos ;;
        6) build_windows ;;
        7) build_linux ;;
        8) build_all ;;
        9) 
            flutter clean
            flutter pub get
            echo -e "${GREEN}✅ Project cleaned and ready for rebuild${NC}"
            ;;
    esac
}

# Run the appropriate function based on arguments
if [ $# -eq 0 ]; then
    show_build_menu
else
    main_build "$1"
fi