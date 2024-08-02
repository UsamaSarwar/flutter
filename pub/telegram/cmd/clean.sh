#!/bin/sh

# Clean Flutter build artifacts
flutter clean

# Clean iOS Pods and project
echo "Cleaning iOS..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
pod deintegrate
pod cache clean --all
pod install
cd ..

# Clean Android Gradle
echo "Cleaning Android..."
cd android
./gradlew clean
rm -rf .gradle
cd ..

# Optionally, clean up the .pub-cache hosted directory
echo "Cleaning Flutter pub cache..."
flutter pub cache repair

# Clean up project-level .dart_tool directory
echo "Cleaning project .dart_tool directory..."
rm -rf .dart_tool

echo "All cleanings are done."