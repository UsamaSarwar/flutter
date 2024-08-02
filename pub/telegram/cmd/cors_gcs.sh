#!/bin/sh

# This script configures CORS (Cross-Origin Resource Sharing) settings for a Google Cloud Storage bucket.

# Ensure the Google Cloud SDK is installed and updated
# This ensures you have the latest version of gcloud and gsutil
echo "Updating Google Cloud SDK..."
gcloud components update

# Authenticate with Google Cloud
# This opens a browser window for you to log in with your Google account
echo "Authenticating with Google Cloud..."
gcloud auth login

# Prompt for project ID
# Reads the project ID from user input and sets it for the gcloud session
echo "Enter your Google Cloud Project ID:"
read PROJECT_ID
gcloud config set project $PROJECT_ID

# Set CORS configuration
# cors.json should be a JSON file with your CORS settings
#* [
#*   {
#*     "origin": ["*"],
#*     "method": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
#*     "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
#*     "maxAgeSeconds": 3600
#*   }
#* ]
# The above configuration allows all origins, specifies the Content-Type response header, allows GET, HEAD, and POST methods, and caches preflight response for 1 hour
# This command sets the CORS configuration for your Google Cloud Storage bucket
echo "Setting CORS configuration from cors.json for the bucket..."
gsutil cors set cors.json gs://$PROJECT_ID.appspot.com

# Verify CORS settings
# Retrieves and displays the current CORS settings for your bucket
echo "Retrieving current CORS configuration for the bucket..."
gsutil cors get gs://$PROJECT_ID.appspot.com

# Additional commands for managing buckets and objects in Google Cloud Storage

# List all buckets in the current project
# This command lists all buckets associated with your current project
echo "Listing all buckets in the project..."
gsutil ls

# Creating a new bucket
# Uncomment the following lines to create a new bucket
# echo "Creating a new bucket..."
# gsutil mb gs://<NEW_BUCKET_NAME>.appspot.com

# Uploading files to a bucket
# Uncomment the following lines to upload a file to a bucket
# echo "Uploading file to bucket..."
# gsutil cp <FILE_TO_UPLOAD> gs://<BUCKET_NAME>.appspot.com/<OPTIONAL_PATH_IN_BUCKET>

# Deleting a bucket
# Be very careful with this command as it deletes the entire bucket and its contents
# Uncomment the following lines to delete a bucket
# echo "Deleting a bucket..."
# gsutil rm -r gs://<BUCKET_NAME>.appspot.com

echo "CORS configuration and additional commands completed."