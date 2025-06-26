#!/bin/bash

# Google Cloud Storage CORS Configuration Script
# Compatible with latest gcloud SDK and gsutil

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check if gcloud is installed
check_gcloud() {
    if ! command -v gcloud &> /dev/null; then
        echo -e "${RED}❌ Google Cloud SDK not found!${NC}"
        echo -e "${YELLOW}💡 Install from: https://cloud.google.com/sdk/docs/install${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Google Cloud SDK found${NC}"
}

# Check if gsutil is available
check_gsutil() {
    if ! command -v gsutil &> /dev/null; then
        echo -e "${RED}❌ gsutil not found!${NC}"
        echo -e "${YELLOW}💡 Install Google Cloud SDK first${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ gsutil found${NC}"
}

# Show GCS menu
show_gcs_menu() {
    echo -e "${CYAN}☁️ Google Cloud Storage CORS Manager${NC}"
    echo ""
    echo -e "${WHITE}Authentication & Setup:${NC}"
    echo -e "${GREEN}1.${NC} Authenticate with Google Cloud"
    echo -e "${GREEN}2.${NC} Set Project ID"
    echo -e "${GREEN}3.${NC} Update Cloud SDK"
    echo ""
    echo -e "${WHITE}CORS Configuration:${NC}"
    echo -e "${GREEN}4.${NC} Set CORS (Interactive)"
    echo -e "${GREEN}5.${NC} Set CORS from JSON file"
    echo -e "${GREEN}6.${NC} View Current CORS"
    echo -e "${GREEN}7.${NC} Remove CORS"
    echo ""
    echo -e "${WHITE}Bucket Management:${NC}"
    echo -e "${GREEN}8.${NC} List Buckets"
    echo -e "${GREEN}9.${NC} Create Bucket"
    echo -e "${GREEN}10.${NC} Upload File"
    echo -e "${GREEN}11.${NC} Download File"
    echo -e "${GREEN}12.${NC} Delete Bucket"
    echo ""
    read -p "Enter choice (1-12): " gcs_choice
    
    case $gcs_choice in
        1) authenticate_gcloud ;;
        2) set_project_id ;;
        3) update_sdk ;;
        4) set_cors_interactive ;;
        5) set_cors_from_file ;;
        6) view_cors ;;
        7) remove_cors ;;
        8) list_buckets ;;
        9) create_bucket ;;
        10) upload_file ;;
        11) download_file ;;
        12) delete_bucket ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Authenticate with Google Cloud
authenticate_gcloud() {
    echo -e "${YELLOW}🔐 Authenticating with Google Cloud...${NC}"
    gcloud auth login
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Authentication successful${NC}"
    else
        echo -e "${RED}❌ Authentication failed${NC}"
        exit 1
    fi
}

# Set project ID
set_project_id() {
    echo -e "${YELLOW}🔧 Setting Google Cloud Project${NC}"
    
    # Show available projects
    echo -e "${CYAN}Available projects:${NC}"
    gcloud projects list
    echo ""
    
    read -p "Enter your Google Cloud Project ID: " PROJECT_ID
    
    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}❌ Project ID cannot be empty${NC}"
        return
    fi
    
    gcloud config set project $PROJECT_ID
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Project set to: $PROJECT_ID${NC}"
    else
        echo -e "${RED}❌ Failed to set project${NC}"
    fi
}

# Update Cloud SDK
update_sdk() {
    echo -e "${YELLOW}⬆️ Updating Google Cloud SDK...${NC}"
    gcloud components update
    echo -e "${GREEN}✅ SDK updated${NC}"
}

# Set CORS interactively
set_cors_interactive() {
    echo -e "${YELLOW}🔧 Interactive CORS Configuration${NC}"
    
    read -p "Enter bucket name (without gs://): " BUCKET_NAME
    if [ -z "$BUCKET_NAME" ]; then
        echo -e "${RED}❌ Bucket name cannot be empty${NC}"
        return
    fi
    
    read -p "Enter allowed origins (comma-separated, * for all): " ORIGINS
    ORIGINS=${ORIGINS:-"*"}
    
    read -p "Enter allowed methods (comma-separated): " METHODS
    METHODS=${METHODS:-"GET,POST,PUT,DELETE,OPTIONS"}
    
    read -p "Enter max age seconds (default 3600): " MAX_AGE
    MAX_AGE=${MAX_AGE:-3600}
    
    # Create temporary CORS file
    cat > /tmp/cors.json << EOF
[
  {
    "origin": ["${ORIGINS//,/\",\"}"],
    "method": ["${METHODS//,/\",\"}"],
    "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
    "maxAgeSeconds": $MAX_AGE
  }
]
EOF
    
    echo -e "${YELLOW}🔧 Setting CORS configuration...${NC}"
    gsutil cors set /tmp/cors.json gs://$BUCKET_NAME
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ CORS configuration set successfully${NC}"
        rm /tmp/cors.json
    else
        echo -e "${RED}❌ Failed to set CORS configuration${NC}"
    fi
}

# Set CORS from JSON file
set_cors_from_file() {
    read -p "Enter bucket name (without gs://): " BUCKET_NAME
    read -p "Enter CORS JSON file path: " CORS_FILE
    
    if [ ! -f "$CORS_FILE" ]; then
        echo -e "${RED}❌ CORS file not found: $CORS_FILE${NC}"
        return
    fi
    
    echo -e "${YELLOW}🔧 Setting CORS from file...${NC}"
    gsutil cors set $CORS_FILE gs://$BUCKET_NAME
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ CORS configuration set from file${NC}"
    else
        echo -e "${RED}❌ Failed to set CORS configuration${NC}"
    fi
}

# View current CORS
view_cors() {
    read -p "Enter bucket name (without gs://): " BUCKET_NAME
    
    echo -e "${YELLOW}👁️  Retrieving CORS configuration...${NC}"
    gsutil cors get gs://$BUCKET_NAME
}

# Remove CORS
remove_cors() {
    read -p "Enter bucket name (without gs://): " BUCKET_NAME
    
    echo -e "${RED}⚠️  This will remove all CORS configuration!${NC}"
    read -p "Are you sure? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        # Create empty CORS file
        echo "[]" > /tmp/empty_cors.json
        gsutil cors set /tmp/empty_cors.json gs://$BUCKET_NAME
        rm /tmp/empty_cors.json
        echo -e "${GREEN}✅ CORS configuration removed${NC}"
    else
        echo -e "${YELLOW}❌ Operation cancelled${NC}"
    fi
}

# List buckets
list_buckets() {
    echo -e "${YELLOW}📋 Listing all buckets...${NC}"
    gsutil ls
}

# Create bucket
create_bucket() {
    read -p "Enter new bucket name: " BUCKET_NAME
    read -p "Enter location (e.g., us-central1): " LOCATION
    LOCATION=${LOCATION:-"us-central1"}
    
    echo -e "${YELLOW}🪣 Creating bucket...${NC}"
    gsutil mb -l $LOCATION gs://$BUCKET_NAME
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Bucket created: gs://$BUCKET_NAME${NC}"
    else
        echo -e "${RED}❌ Failed to create bucket${NC}"
    fi
}

# Upload file
upload_file() {
    read -p "Enter local file path: " FILE_PATH
    read -p "Enter bucket name: " BUCKET_NAME
    read -p "Enter destination path (optional): " DEST_PATH
    
    if [ ! -f "$FILE_PATH" ]; then
        echo -e "${RED}❌ File not found: $FILE_PATH${NC}"
        return
    fi
    
    if [ -z "$DEST_PATH" ]; then
        DEST_PATH=$(basename "$FILE_PATH")
    fi
    
    echo -e "${YELLOW}⬆️ Uploading file...${NC}"
    gsutil cp "$FILE_PATH" gs://$BUCKET_NAME/$DEST_PATH
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File uploaded successfully${NC}"
    else
        echo -e "${RED}❌ Upload failed${NC}"
    fi
}

# Download file
download_file() {
    read -p "Enter bucket name: " BUCKET_NAME
    read -p "Enter file path in bucket: " FILE_PATH
    read -p "Enter local destination (optional): " LOCAL_PATH
    
    if [ -z "$LOCAL_PATH" ]; then
        LOCAL_PATH=$(basename "$FILE_PATH")
    fi
    
    echo -e "${YELLOW}⬇️ Downloading file...${NC}"
    gsutil cp gs://$BUCKET_NAME/$FILE_PATH "$LOCAL_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ File downloaded successfully${NC}"
    else
        echo -e "${RED}❌ Download failed${NC}"
    fi
}

# Delete bucket
delete_bucket() {
    read -p "Enter bucket name to delete: " BUCKET_NAME
    
    echo -e "${RED}⚠️  This will permanently delete the bucket and ALL its contents!${NC}"
    read -p "Type 'DELETE' to confirm: " confirm
    
    if [ "$confirm" = "DELETE" ]; then
        echo -e "${YELLOW}🗑️  Deleting bucket...${NC}"
        gsutil rm -r gs://$BUCKET_NAME
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Bucket deleted${NC}"
        else
            echo -e "${RED}❌ Failed to delete bucket${NC}"
        fi
    else
        echo -e "${YELLOW}❌ Deletion cancelled${NC}"
    fi
}

# Main execution
main() {
    check_gcloud
    check_gsutil
    
    case ${1:-"menu"} in
        "auth") authenticate_gcloud ;;
        "project") set_project_id ;;
        "update") update_sdk ;;
        "cors") set_cors_interactive ;;
        "cors-file") set_cors_from_file ;;
        "view-cors") view_cors ;;
        "remove-cors") remove_cors ;;
        "list") list_buckets ;;
        "create") create_bucket ;;
        "upload") upload_file ;;
        "download") download_file ;;
        "delete") delete_bucket ;;
        *) show_gcs_menu ;;
    esac
}

main "$@"