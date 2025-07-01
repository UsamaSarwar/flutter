#!/bin/bash

# Flutter Project Setup Script
# Quick project initialization and environment configuration

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check Flutter installation
check_flutter_installation() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter not found!${NC}"
        echo -e "${YELLOW}💡 Install Flutter from: https://flutter.dev/docs/get-started/install${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Flutter found${NC}"
}

# Create new Flutter project
create_new_project() {
    echo -e "${CYAN}🚀 Create New Flutter Project${NC}"
    echo ""
    
    read -p "Enter project name: " project_name
    
    if [ -z "$project_name" ]; then
        echo -e "${RED}❌ Project name is required${NC}"
        return 1
    fi
    
    # Validate project name
    if [[ ! "$project_name" =~ ^[a-z][a-z0-9_]*$ ]]; then
        echo -e "${RED}❌ Invalid project name. Use lowercase letters, numbers, and underscores only.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Select project template:${NC}"
    echo -e "${GREEN}1.${NC} App (default)"
    echo -e "${GREEN}2.${NC} Module"
    echo -e "${GREEN}3.${NC} Package"
    echo -e "${GREEN}4.${NC} Plugin"
    echo ""
    read -p "Enter choice (1-4): " template_choice
    
    local template=""
    case $template_choice in
        1) template="app" ;;
        2) template="module" ;;
        3) template="package" ;;
        4) template="plugin" ;;
        *) template="app" ;;
    esac
    
    echo -e "${YELLOW}Select platforms to support:${NC}"
    echo -e "${GREEN}1.${NC} All platforms"
    echo -e "${GREEN}2.${NC} Mobile only (iOS, Android)"
    echo -e "${GREEN}3.${NC} Custom selection"
    echo ""
    read -p "Enter choice (1-3): " platform_choice
    
    local platforms=""
    case $platform_choice in
        1) platforms="" ;; # Default includes all
        2) platforms="--platforms=ios,android" ;;
        3)
            echo -e "${YELLOW}Select platforms (space-separated):${NC}"
            echo -e "${WHITE}Available: ios android web macos windows linux${NC}"
            read -p "Enter platforms: " custom_platforms
            platforms="--platforms=$custom_platforms"
            ;;
    esac
    
    echo -e "${YELLOW}🔨 Creating Flutter project...${NC}"
    
    if [ -n "$platforms" ]; then
        flutter create --template=$template $platforms "$project_name"
    else
        flutter create --template=$template "$project_name"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Project '$project_name' created successfully!${NC}"
        echo -e "${YELLOW}📍 Location: $(pwd)/$project_name${NC}"
        
        # Setup additional configurations
        setup_project_configs "$project_name"
    else
        echo -e "${RED}❌ Project creation failed${NC}"
    fi
}

# Setup project configurations
setup_project_configs() {
    local project_name=$1
    
    echo -e "${YELLOW}⚙️ Setting up project configurations...${NC}"
    
    cd "$project_name" || return 1
    
    # Create .gitignore additions
    cat >> .gitignore << 'EOF'

# Additional Flutter/Dart ignores
*.lock
.flutter-plugins-dependencies
.dart_tool/
.packages
pubspec.lock

# IDE
.vscode/
.idea/
*.iml
*.ipr
*.iws

# OS
.DS_Store
Thumbs.db

# Build outputs
build/
*.apk
*.ipa
*.app

# Environment
.env
.env.local
.env.production
EOF
    
    # Create analysis_options.yaml if it doesn't exist
    if [ ! -f "analysis_options.yaml" ]; then
        cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    prefer_single_quotes: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: false
    prefer_final_fields: true
    unnecessary_this: true
EOF
    fi
    
    # Setup folder structure
    mkdir -p lib/{models,services,widgets,screens,utils}
    mkdir -p test/{unit,widget,integration}
    mkdir -p assets/{images,icons,fonts}
    
    echo -e "${GREEN}✅ Project configuration completed${NC}"
    
    cd ..
}

# Setup development environment
setup_development_environment() {
    echo -e "${CYAN}🛠️ Development Environment Setup${NC}"
    echo ""
    
    check_flutter_installation
    
    echo -e "${YELLOW}🔍 Checking Flutter doctor...${NC}"
    flutter doctor
    echo ""
    
    echo -e "${YELLOW}What would you like to setup?${NC}"
    echo -e "${GREEN}1.${NC} Install common dev dependencies"
    echo -e "${GREEN}2.${NC} Setup IDE configurations"
    echo -e "${GREEN}3.${NC} Install useful Flutter packages"
    echo -e "${GREEN}4.${NC} Setup Git hooks"
    echo -e "${GREEN}5.${NC} All of the above"
    echo ""
    read -p "Enter choice (1-5): " setup_choice
    
    case $setup_choice in
        1|5) install_dev_dependencies ;;
    esac
    
    case $setup_choice in
        2|5) setup_ide_configs ;;
    esac
    
    case $setup_choice in
        3|5) install_useful_packages ;;
    esac
    
    case $setup_choice in
        4|5) setup_git_hooks ;;
    esac
}

# Install common development dependencies
install_dev_dependencies() {
    echo -e "${YELLOW}📦 Installing common dev dependencies...${NC}"
    
    # Check if we're in a Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Not in a Flutter project directory${NC}"
        return 1
    fi
    
    # Add common dev dependencies
    flutter pub add --dev flutter_test flutter_lints
    flutter pub add --dev mockito build_runner
    
    echo -e "${GREEN}✅ Dev dependencies installed${NC}"
}

# Setup IDE configurations
setup_ide_configs() {
    echo -e "${YELLOW}⚙️ Setting up IDE configurations...${NC}"
    
    # VS Code configuration
    mkdir -p .vscode
    
    cat > .vscode/settings.json << 'EOF'
{
    "dart.flutterSdkPath": "",
    "dart.lineLength": 80,
    "dart.closingLabels": true,
    "dart.insertArgumentPlaceholders": false,
    "editor.rulers": [80],
    "editor.tabSize": 2,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true
}
EOF
    
    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter",
            "type": "dart",
            "request": "launch",
            "program": "lib/main.dart"
        },
        {
            "name": "Flutter (Profile)",
            "type": "dart",
            "request": "launch",
            "program": "lib/main.dart",
            "flutterMode": "profile"
        }
    ]
}
EOF
    
    # Create tasks.json for VS Code
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Flutter: Build APK",
            "type": "shell",
            "command": "flutter",
            "args": ["build", "apk"],
            "group": "build"
        },
        {
            "label": "Flutter: Run Tests",
            "type": "shell",
            "command": "flutter",
            "args": ["test"],
            "group": "test"
        }
    ]
}
EOF
    
    echo -e "${GREEN}✅ IDE configurations created${NC}"
}

# Install useful Flutter packages
install_useful_packages() {
    echo -e "${YELLOW}📦 Installing useful Flutter packages...${NC}"
    
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Not in a Flutter project directory${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Select packages to install:${NC}"
    echo -e "${GREEN}1.${NC} State Management (provider, riverpod)"
    echo -e "${GREEN}2.${NC} HTTP & Networking (dio, http)"
    echo -e "${GREEN}3.${NC} Local Storage (shared_preferences, hive)"
    echo -e "${GREEN}4.${NC} UI Packages (flutter_svg, cached_network_image)"
    echo -e "${GREEN}5.${NC} All packages"
    echo ""
    read -p "Enter choice (1-5): " package_choice
    
    case $package_choice in
        1|5)
            flutter pub add provider
            flutter pub add flutter_riverpod
            ;;
    esac
    
    case $package_choice in
        2|5)
            flutter pub add dio
            flutter pub add http
            ;;
    esac
    
    case $package_choice in
        3|5)
            flutter pub add shared_preferences
            flutter pub add hive
            flutter pub add --dev hive_generator
            ;;
    esac
    
    case $package_choice in
        4|5)
            flutter pub add flutter_svg
            flutter pub add cached_network_image
            ;;
    esac
    
    flutter pub get
    echo -e "${GREEN}✅ Packages installed${NC}"
}

# Setup Git hooks
setup_git_hooks() {
    echo -e "${YELLOW}🔗 Setting up Git hooks...${NC}"
    
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}⚠️  Not a Git repository. Initializing...${NC}"
        git init
    fi
    
    # Create pre-commit hook
    mkdir -p .git/hooks
    
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running pre-commit checks..."

# Check Dart formatting
echo "Checking Dart formatting..."
dart format --set-exit-if-changed lib/ test/

if [ $? -ne 0 ]; then
    echo "❌ Code formatting check failed"
    echo "Run 'dart format lib/ test/' to fix formatting"
    exit 1
fi

# Run Dart analyzer
echo "Running Dart analyzer..."
dart analyze

if [ $? -ne 0 ]; then
    echo "❌ Static analysis failed"
    exit 1
fi

# Run tests
echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
    echo "❌ Tests failed"
    exit 1
fi

echo "✅ All pre-commit checks passed"
EOF
    
    chmod +x .git/hooks/pre-commit
    
    echo -e "${GREEN}✅ Git hooks setup completed${NC}"
}

# Setup platform-specific configurations
setup_platform_configs() {
    echo -e "${CYAN}📱 Platform-specific Setup${NC}"
    echo ""
    
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Not in a Flutter project directory${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Select platform to configure:${NC}"
    echo -e "${GREEN}1.${NC} Android"
    echo -e "${GREEN}2.${NC} iOS"
    echo -e "${GREEN}3.${NC} Web"
    echo -e "${GREEN}4.${NC} macOS"
    echo -e "${GREEN}5.${NC} Windows"
    echo -e "${GREEN}6.${NC} Linux"
    echo ""
    read -p "Enter choice (1-6): " platform_choice
    
    case $platform_choice in
        1) setup_android_config ;;
        2) setup_ios_config ;;
        3) setup_web_config ;;
        4) setup_macos_config ;;
        5) setup_windows_config ;;
        6) setup_linux_config ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Setup Android configuration
setup_android_config() {
    echo -e "${YELLOW}🤖 Setting up Android configuration...${NC}"
    
    if [ ! -d "android" ]; then
        echo -e "${RED}❌ Android directory not found${NC}"
        return 1
    fi
    
    # Update gradle settings
    echo -e "${YELLOW}⚙️ Updating Gradle settings...${NC}"
    
    # Create gradle.properties additions
    cat >> android/gradle.properties << 'EOF'

# Flutter Performance
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
android.enableR8=true
EOF
    
    echo -e "${GREEN}✅ Android configuration completed${NC}"
}

# Setup iOS configuration
setup_ios_config() {
    echo -e "${YELLOW}🍎 Setting up iOS configuration...${NC}"
    
    if [ ! -d "ios" ]; then
        echo -e "${RED}❌ iOS directory not found${NC}"
        return 1
    fi
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ iOS setup is only available on macOS${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}⚙️ Updating iOS deployment target...${NC}"
    
    # Update iOS deployment target in Podfile
    if [ -f "ios/Podfile" ]; then
        sed -i '' "s/# platform :ios, '9.0'/platform :ios, '11.0'/" ios/Podfile
        echo -e "${GREEN}✅ iOS deployment target updated${NC}"
    fi
    
    echo -e "${GREEN}✅ iOS configuration completed${NC}"
}

# Setup Web configuration
setup_web_config() {
    echo -e "${YELLOW}🌐 Setting up Web configuration...${NC}"
    
    if [ ! -d "web" ]; then
        echo -e "${YELLOW}Adding web support...${NC}"
        flutter create --platforms=web .
    fi
    
    echo -e "${GREEN}✅ Web configuration completed${NC}"
}

# Setup macOS configuration
setup_macos_config() {
    echo -e "${YELLOW}🖥️ Setting up macOS configuration...${NC}"
    
    if [ ! -d "macos" ]; then
        echo -e "${YELLOW}Adding macOS support...${NC}"
        flutter create --platforms=macos .
    fi
    
    echo -e "${GREEN}✅ macOS configuration completed${NC}"
}

# Setup Windows configuration
setup_windows_config() {
    echo -e "${YELLOW}🪟 Setting up Windows configuration...${NC}"
    
    if [ ! -d "windows" ]; then
        echo -e "${YELLOW}Adding Windows support...${NC}"
        flutter create --platforms=windows .
    fi
    
    echo -e "${GREEN}✅ Windows configuration completed${NC}"
}

# Setup Linux configuration
setup_linux_config() {
    echo -e "${YELLOW}🐧 Setting up Linux configuration...${NC}"
    
    if [ ! -d "linux" ]; then
        echo -e "${YELLOW}Adding Linux support...${NC}"
        flutter create --platforms=linux .
    fi
    
    echo -e "${GREEN}✅ Linux configuration completed${NC}"
}

# Show setup menu
show_setup_menu() {
    echo -e "${CYAN}⚙️ Flutter Project Setup${NC}"
    echo ""
    echo -e "${WHITE}Project Creation:${NC}"
    echo -e "${GREEN}1.${NC} Create New Flutter Project"
    echo -e "${GREEN}2.${NC} Setup Development Environment"
    echo ""
    echo -e "${WHITE}Configuration:${NC}"
    echo -e "${GREEN}3.${NC} Setup Platform Configurations"
    echo -e "${GREEN}4.${NC} Install Dev Dependencies"
    echo -e "${GREEN}5.${NC} Setup IDE Configurations"
    echo -e "${GREEN}6.${NC} Setup Git Hooks"
    echo ""
    read -p "Enter choice (1-6): " setup_choice
    
    case $setup_choice in
        1) create_new_project ;;
        2) setup_development_environment ;;
        3) setup_platform_configs ;;
        4) install_dev_dependencies ;;
        5) setup_ide_configs ;;
        6) setup_git_hooks ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    check_flutter_installation
    
    case ${1:-"menu"} in
        "project") create_new_project ;;
        "environment") setup_development_environment ;;
        "platform") setup_platform_configs ;;
        "deps") install_dev_dependencies ;;
        "ide") setup_ide_configs ;;
        "git") setup_git_hooks ;;
        "tools") setup_development_environment ;;
        *) show_setup_menu ;;
    esac
}

main "$@"