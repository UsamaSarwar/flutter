#!/bin/sh

# Step 1: Install Firebase CLI
# Ensure you have Node.js installed, then run `npm install -g firebase-tools` to install Firebase CLI globally.

# Step 2: Login to Firebase
# Run `firebase login` to log in via the browser and authenticate the firebase tool.

# Step 3: Initialize your Firebase project
# Navigate to your project directory and run `firebase init`. Follow the prompts to set up Hosting and link the project to a Firebase project.

# Step 4: Build the Flutter web app in release mode with specific renderer and without tree shaking icons for better performance
flutter build web --release --web-renderer=canvaskit --no-tree-shake-icons
if [ $? -eq 0 ]; then
    echo "Build success"
else
    echo "Build failed"
    exit 1
fi 

# Step 5: Deploy the Flutter web app to Firebase Hosting
firebase deploy --only hosting
if [ $? -eq 0 ]; then
    echo "Deploy success"
else
    echo "Deploy failed"
    exit 1
fi

# Note: Before running this script, ensure you have completed the setup steps for Firebase CLI and you are in the root of your Flutter project.
