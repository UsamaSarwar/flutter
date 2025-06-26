#!/bin/bash

# Firebase Deploy Script for Flutter Web
# Compatible with Flutter 3.x and latest Firebase tools

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

# Check if Firebase CLI is installed
check_firebase_cli() {
    if ! command -v firebase &> /dev/null; then
        echo -e "${RED}❌ Firebase CLI not found!${NC}"
        echo -e "${YELLOW}💡 Install with: npm install -g firebase-tools${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Firebase CLI found${NC}"
}

# Check if user is logged in to Firebase
check_firebase_auth() {
    if ! firebase projects:list &> /dev/null; then
        echo -e "${RED}❌ Not logged in to Firebase!${NC}"
        echo -e "${YELLOW}💡 Run: firebase login${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Firebase authentication verified${NC}"
}

# Show deployment menu
show_deploy_menu() {
    echo -e "${CYAN}🚀 Firebase Deployment${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Setup Firebase (init)"
    echo -e "${GREEN}2.${NC} Build & Deploy Web App"
    echo -e "${GREEN}3.${NC} Deploy Only (no build)"
    echo -e "${GREEN}4.${NC} Deploy with Custom Options"
    echo -e "${GREEN}5.${NC} Preview Deployment"
    echo -e "${GREEN}6.${NC} View Deployment History"
    echo -e "${GREEN}7.${NC} Rollback Deployment"
    echo ""
    read -p "Enter choice (1-7): " deploy_choice
    
    case $deploy_choice in
        1) firebase_init ;;
        2) build_and_deploy ;;
        3) deploy_only ;;
        4) deploy_custom ;;
        5) preview_deploy ;;
        6) deployment_history ;;
        7) rollback_deploy ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Initialize Firebase
firebase_init() {
    echo -e "${YELLOW}🔧 Initializing Firebase project...${NC}"
    firebase init
    echo -e "${GREEN}✅ Firebase initialized${NC}"
}

# Build and deploy
build_and_deploy() {
    echo -e "${YELLOW}🔨 Building Flutter web app...${NC}"
    
    # Build with optimizations
    flutter build web --release --web-renderer=canvaskit --no-tree-shake-icons
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Build successful${NC}"
        echo -e "${YELLOW}🚀 Deploying to Firebase...${NC}"
        
        firebase deploy --only hosting
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Deployment successful!${NC}"
            echo -e "${CYAN}🌐 Your app is now live!${NC}"
        else
            echo -e "${RED}❌ Deployment failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Build failed${NC}"
        exit 1
    fi
}

# Deploy only (no build)
deploy_only() {
    echo -e "${YELLOW}🚀 Deploying existing build...${NC}"
    
    if [ ! -d "build/web" ]; then
        echo -e "${RED}❌ No web build found! Run build first.${NC}"
        exit 1
    fi
    
    firebase deploy --only hosting
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Deployment successful!${NC}"
    else
        echo -e "${RED}❌ Deployment failed${NC}"
        exit 1
    fi
}

# Deploy with custom options
deploy_custom() {
    echo -e "${YELLOW}🔧 Custom deployment options${NC}"
    echo ""
    
    echo -e "${WHITE}Web Renderer:${NC}"
    echo -e "${GREEN}1.${NC} CanvasKit (better performance)"
    echo -e "${GREEN}2.${NC} HTML (better compatibility)"
    echo -e "${GREEN}3.${NC} Auto (Flutter decides)"
    read -p "Choose renderer (1-3): " renderer_choice
    
    case $renderer_choice in
        1) renderer="canvaskit" ;;
        2) renderer="html" ;;
        3) renderer="auto" ;;
        *) renderer="canvaskit" ;;
    esac
    
    read -p "Enable tree shaking for icons? (y/N): " tree_shake
    if [[ $tree_shake =~ ^[Yy]$ ]]; then
        tree_shake_flag=""
    else
        tree_shake_flag="--no-tree-shake-icons"
    fi
    
    read -p "Enable source maps? (y/N): " source_maps
    if [[ $source_maps =~ ^[Yy]$ ]]; then
        source_maps_flag="--source-maps"
    else
        source_maps_flag=""
    fi
    
    echo -e "${YELLOW}🔨 Building with custom options...${NC}"
    flutter build web --release --web-renderer=$renderer $tree_shake_flag $source_maps_flag
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Build successful${NC}"
        echo -e "${YELLOW}🚀 Deploying...${NC}"
        firebase deploy --only hosting
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Deployment successful!${NC}"
        else
            echo -e "${RED}❌ Deployment failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Build failed${NC}"
        exit 1
    fi
}

# Preview deployment
preview_deploy() {
    echo -e "${YELLOW}👁️  Creating deployment preview...${NC}"
    
    # Build first if needed
    if [ ! -d "build/web" ]; then
        echo -e "${YELLOW}🔨 Building web app first...${NC}"
        flutter build web --release --web-renderer=canvaskit
    fi
    
    firebase hosting:channel:deploy preview
    echo -e "${GREEN}✅ Preview created!${NC}"
}

# Show deployment history
deployment_history() {
    echo -e "${YELLOW}📜 Deployment history...${NC}"
    firebase hosting:sites:list
}

# Rollback deployment
rollback_deploy() {
    echo -e "${YELLOW}⏪ Rolling back deployment...${NC}"
    firebase hosting:clone --only hosting
    echo -e "${GREEN}✅ Rollback completed${NC}"
}

# Main execution
main() {
    check_flutter_project
    check_firebase_cli
    check_firebase_auth
    
    case ${1:-"menu"} in
        "init") firebase_init ;;
        "build") build_and_deploy ;;
        "deploy") deploy_only ;;
        "custom") deploy_custom ;;
        "preview") preview_deploy ;;
        "history") deployment_history ;;
        "rollback") rollback_deploy ;;
        *) show_deploy_menu ;;
    esac
}

main "$@"
