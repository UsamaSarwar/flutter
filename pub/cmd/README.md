[![cmd](https://img.shields.io/pub/v/cmd.svg?label=cmd&color=blue)](https://pub.dev/packages/cmd)
[![Points](https://img.shields.io/pub/points/cmd)](https://pub.dev/packages/cmd/score)
[![Popularity](https://img.shields.io/pub/popularity/cmd)](https://pub.dev/packages/cmd/score)
[![Likes](https://img.shields.io/pub/likes/cmd)](https://pub.dev/packages/cmd/score)
[![Telegram](https://img.shields.io/badge/Telegram--blue?logo=telegram&logoColor=white)](https://t.me/UsamaSarwar)
[![WhatsApp](https://img.shields.io/badge/WhatsApp--tgreen?logo=whatsapp&logoColor=white)](https://wa.me/923100007773)
[![Contribute Now](https://img.shields.io/badge/Contribute--blue?logo=Github&logoColor=white)](https://github.com/UsamaSarwar/flutter/blob/main/pub/cmd/CONTRIBUTING.md)
[![Donate Now](https://img.shields.io/badge/Donate--blue?logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/UsamaSarwar)

<img align="left" alt="flutter cmd" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/assets/path.png" height="auto" width ="30%"/>
<p align="justify">
Flutter, a mobile development UI kit managed by Google comes with the handy CLI (Command Line Interface). It lets you do the same tasks that you perform using IDE. CMD package helps you quickly running the common CLI commands that are used in almost all Flutter projects by running pre-written scripts. Flutter developers find it difficult to type commands again and again and sometimes you need to run a series of commands one after another. This is where CMD package is helpful. Flutter's <b>cmd</b> package helps developers to save time by running scripts for performing the below operations:
</p>

<img align="right" alt="flutter cmd" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/assets/coding.gif" height="auto" width ="150"/>

## ✨ Features

### 🎯 Interactive Dialer Interface
- Modern terminal-based menu system
- Easy navigation between script categories
- Color-coded interface for better UX

### 🏥 Environment & Doctor
- [flutter doctor](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/doctor.sh) - Advanced environment checking
- Channel management and version control
- Configuration management

### 🏃 Run & Debug
- [flutter run](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/run.sh) - Enhanced run commands
- Device selection and management
- Flavor and architecture support
- Performance monitoring options

### 🔨 Build & Deploy
- [flutter build](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/build.sh) - Cross-platform building
- [firebase deploy](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/deploy.sh) - Firebase deployment
- Automated build pipelines
- Size analysis and optimization

### 🔐 App Signing
- **NEW!** [Android app signing](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/android_signing.sh) - Complete Android signing workflow
- **NEW!** [iOS app signing](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/ios_signing.sh) - iOS provisioning and certificates
- Keystore management and security

### 🧪 Testing & Analysis
- **NEW!** [Comprehensive testing](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/testing.sh) - Unit, widget, integration tests
- **NEW!** [Performance testing](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/performance.sh) - Memory, CPU, startup profiling
- Code analysis and formatting
- Coverage reporting

### 🧹 Maintenance
- [flutter clean](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/clean.sh) - Deep cleaning utilities
- [flutter pub](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/pub.sh) - Package management
- Cache management and optimization

### 🔧 Setup & Tools
- **NEW!** [Project setup](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/setup.sh) - Quick project initialization
- State management setup (Provider, Bloc, Riverpod)
- Firebase integration
- Environment configuration

### 🖥️ Platform-Specific Tools
- **NEW!** [macOS utilities](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/macos_utils.sh) - Xcode, CocoaPods, Simulator management
- **NEW!** [Windows utilities](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/windows_utils.sh) - Visual Studio, MSBuild, package management

### ☁️ Cloud & Deploy
- [firebase deploy](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/deploy.sh) - Firebase hosting deployment
- [gsutil cors](https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/cmd/cors_gcs.sh) - Google Cloud Storage configuration

## Installation

Add **cmd** as dev_dependency by running the command below:

```bash
flutter pub add -d cmd
```

**OR**

Add **cmd** this in your `pubspec.yaml`:

```yaml
dev_dependencies:
  cmd:
```

Run the following commands below to install **cmd**:

```bash
flutter pub get
dart run cmd:install
```

In your project root directory you will find a folder **cmd** that contains all available scripts.

<img align="right" alt="FAQs" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/assets/faq.png" height="auto" width ="30%"/>

```bash
├── project
│   ├── cmd
│   │   ├── dialer.sh              # 🎯 Interactive main menu
│   │   ├── doctor.sh              # 🏥 Environment checking
│   │   ├── run.sh                 # 🏃 Run & debug utilities
│   │   ├── build.sh               # 🔨 Build for all platforms
│   │   ├── clean.sh               # 🧹 Deep cleaning
│   │   ├── pub.sh                 # 📦 Package management
│   │   ├── android_signing.sh     # 🔐 Android signing
│   │   ├── ios_signing.sh         # 🍎 iOS signing
│   │   ├── testing.sh             # 🧪 Testing & analysis
│   │   ├── performance.sh         # ⚡ Performance testing
│   │   ├── setup.sh               # 🔧 Project setup
│   │   ├── deploy.sh              # 🚀 Firebase deployment
│   │   ├── cors_gcs.sh            # ☁️ Google Cloud Storage
│   │   ├── macos_utils.sh         # 🍎 macOS utilities
│   │   └── windows_utils.sh       # 🪟 Windows utilities
```

## Usage

### 🎯 Interactive Dialer (Recommended)

Navigate to your project's cmd directory and run the main dialer:

```bash
cd cmd
./dialer.sh
```

The dialer provides an intuitive menu system with categories:
- 🏥 Environment & Doctor
- 🏃 Run & Debug  
- 🔨 Build & Deploy
- 🧹 Clean & Maintenance
- 📦 Package Management
- 🔐 App Signing
- 🧪 Testing & Analysis
- ⚡ Performance
- 🔧 Setup & Tools
- ☁️ Cloud & Deploy

### 📱 Individual Scripts

You can also run individual scripts directly:

```bash
# Make scripts executable (first time only)
chmod +x *.sh

# Run specific scripts
./doctor.sh          # Environment check
./build.sh           # Build for platforms
./testing.sh         # Run tests
./android_signing.sh # Sign Android apps
./setup.sh           # Setup new projects
```

## Usage in VS Code 🧑🏻‍💻

- Install [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) Extension
- Right click on Script you want to execute and select `Run Code`
- Alternatively use these short keys <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>N</kbd> when the script is opened.

## What's New in v1.0.0 🎉

### 🎯 Interactive Dialer Interface
- Modern terminal-based navigation
- Color-coded menus and feedback
- Intuitive categorization

### 🔐 Complete App Signing Solution
- Android keystore creation and management
- iOS provisioning and certificate handling
- Automated signing configuration

### 🧪 Comprehensive Testing Suite
- Unit, widget, and integration testing
- Performance profiling and analysis
- Code coverage reporting
- Continuous testing with file watching

### ⚡ Performance Testing Tools
- Memory and CPU profiling
- Startup performance analysis
- Build size optimization
- Frame rate monitoring

### 🔧 Advanced Setup Utilities
- Project templates and scaffolding
- State management setup
- Firebase integration
- Environment configuration

### 🖥️ Platform-Specific Tools
- macOS: Xcode, CocoaPods, Simulator management
- Windows: Visual Studio, MSBuild, package management
- Cross-platform compatibility

### 🚀 Enhanced Build System
- Interactive build options
- Multi-platform builds
- Build size analysis
- Export management

## Contribution 💙

You are warmly welcome for contributing **cmd** package. You may add single line scripts or batch scripts such as `cmd/build.sh`. Checkout this [contribution guide.](https://github.com/UsamaSarwar/flutter/blob/main/pub/cmd/CONTRIBUTING.md)

<p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/assets/contribution.svg" alt="cmd contributions" /> </p>

<p align="center">Open Source Contributor from <b>Punjab, Pakistan</b> 🇵🇰 </p>
<div align="center"><br>
<p><a href="https://www.buymeacoffee.com/UsamaSarwar"> <img align="center" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="40" width="168" alt="Buy me a Coffee ☕" /></a></p>
</div>

<br><p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/cmd/assets/cmd.jpg" alt="Flutter cmd package" /> </p>
