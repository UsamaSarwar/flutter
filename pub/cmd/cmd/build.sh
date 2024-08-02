#!/bin/sh

# Ensure the export directory exists and is clean
mkdir -p export && rm -rf export/*

# Flutter Build Section
## Building Flutter APK for release
flutter build apk --release && mkdir -p export/android && cp build/app/outputs/flutter-apk/app-release.apk export/android/app.apk && echo "APK build successful"

## Building Flutter AppBundle for release
flutter build appbundle --release && mkdir -p export/android && cp build/app/outputs/bundle/release/app-release.aab export/android/app.aab && echo "AppBundle build successful"

## Building Flutter for Web
flutter build web --release && mkdir -p export/web && cp -r build/web/* export/web && echo "Web build successful"

## Building Flutter for iOS
flutter build ios --release && mkdir -p export/ios && cp -r build/ios/iphoneos/Runner.app export/ios/Runner.app && echo "iOS build successful"

## Building Flutter for MacOS
flutter build macos --release && mkdir -p export/macos && cp -r build/macos/Build/Products/Release/Runner.app export/macos/Runner.app && echo "MacOS build successful"

## Building Flutter for Linux
# Note: Linux does not produce a single executable by default, so this step remains unchanged.
flutter build linux --release && mkdir -p export/linux && cp -r build/linux/release/bundle/* export/linux && echo "Linux build successful"

## Building Flutter for Windows
flutter build windows --release && mkdir -p export/windows && cp -r build/windows/runner/Release/*.exe export/windows && echo "Windows build successful"

# Debug Build Section
## Building Flutter APK for debug
flutter build apk --debug && echo "Android debug build successful"

## Building Flutter for iOS in debug mode
flutter build ios --debug && echo "iOS debug build successful"

## Building Flutter for Web in debug mode
flutter build web --debug && echo "Web debug build successful"

## Building Flutter for MacOS in debug mode
flutter build macos --debug && echo "MacOS debug build successful"

## Building Flutter for Linux in debug mode
flutter build linux --debug && echo "Linux debug build successful"

## Building Flutter for Windows in debug mode
flutter build windows --debug && echo "Windows debug build successful"

# Maintenance Section
## Cleaning the Flutter project
flutter clean && echo "Project cleaned successfully"

## Getting the Flutter packages
flutter pub get && echo "Packages retrieved successfully"

## Upgrading the Flutter packages
flutter pub upgrade && echo "Packages upgraded successfully"

# Analysis and Testing Section
## Running the Flutter analyzer
flutter analyze && echo "Analyzer ran successfully"

## Formatting the Flutter code
flutter format . && echo "Code formatted successfully"

## Running the Flutter tests
flutter test && echo "Tests ran successfully"

## Running the Flutter driver tests
flutter drive --target=test_driver/app.dart && echo "Driver tests ran successfully"