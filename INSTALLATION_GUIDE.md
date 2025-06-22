# Bookavio - Installation Guide

## Quick Start Guide for Fellow Developers

This guide will help you set up and run the Bookavio Flutter project on your laptop.

## 📋 Prerequisites Checklist

Before starting, make sure you have:

- [ ] **Flutter SDK** (version 3.2.3 or higher)
- [ ] **Git** installed
- [ ] **IDE** (VS Code or Android Studio)
- [ ] **Chrome browser** (for web development)

## 🚀 Step-by-Step Installation

### Step 1: Install Flutter SDK

#### Windows:
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\flutter` (or any location you prefer)
3. Add `C:\flutter\bin` to your system PATH
4. Open Command Prompt and run:
   ```cmd
   flutter doctor
   ```

#### macOS:
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
2. Extract to `/Users/yourusername/flutter`
3. Add to PATH in `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:/Users/yourusername/flutter/bin"
   ```
4. Open Terminal and run:
   ```bash
   flutter doctor
   ```

#### Linux:
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/linux)
2. Extract to `/home/yourusername/flutter`
3. Add to PATH in `~/.bashrc`:
   ```bash
   export PATH="$PATH:/home/yourusername/flutter/bin"
   ```
4. Open Terminal and run:
   ```bash
   flutter doctor
   ```

### Step 2: Install IDE

#### VS Code (Recommended):
1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Install Flutter extension: `flutter`
3. Install Dart extension: `dart`

#### Android Studio:
1. Download from [developer.android.com](https://developer.android.com/studio)
2. Install Flutter plugin
3. Install Dart plugin

### Step 3: Clone and Setup Project

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/bookavio.git
   cd bookavio
   ```

2. **Check Flutter installation**:
   ```bash
   flutter doctor
   ```
   Make sure all checks show ✓ (green checkmarks)

3. **Get project dependencies**:
   ```bash
   flutter pub get
   ```

## 🏃‍♂️ Running the Application

### Option 1: Web (Easiest - Recommended for first run)
```bash
flutter run -d chrome
```
This will open the app in your Chrome browser.

### Option 2: Android
1. **Setup Android Studio**:
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Install Android SDK (API level 21 or higher)
   - Create an Android Virtual Device (AVD) or connect a physical device

2. **Run on Android**:
   ```bash
   flutter run -d android
   ```

### Option 3: iOS (macOS only)
1. Install Xcode from Mac App Store
2. Install iOS Simulator or connect a physical iOS device
3. Run:
   ```bash
   flutter run -d ios
   ```

### Option 4: Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 🔧 Troubleshooting Common Issues

### Issue 1: "flutter command not found"
**Solution**: Make sure Flutter is added to your system PATH

### Issue 2: Dependencies not found
**Solution**: Run these commands:
```bash
flutter clean
flutter pub get
```

### Issue 3: Android build fails
**Solution**:
1. Make sure Android SDK is installed
2. Set ANDROID_HOME environment variable
3. Update Android SDK tools

### Issue 4: iOS build fails (macOS)
**Solution**:
1. Install Xcode from Mac App Store
2. Accept Xcode license: `sudo xcodebuild -license accept`
3. Install iOS Simulator

### Issue 5: Permission errors
**Solution**: For camera/microphone access, check platform-specific permission files

## 📱 Testing the App

Once the app is running, you should see:
- Welcome/Onboarding screens
- Home screen with calendar and services
- Navigation between different screens
- Booking functionality
- Payment processing

## 🛠 Development Commands

```bash
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Clean build cache
flutter clean

# Run tests
flutter test

# Build for release
flutter build apk    # Android
flutter build ios    # iOS
flutter build web    # Web
```

## 📞 Getting Help

If you encounter issues:
1. Check the troubleshooting section above
2. Run `flutter doctor` to identify problems
3. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
4. Create an issue in the GitHub repository

## 🎯 Next Steps

After successful installation:
1. Explore the codebase structure
2. Try making small changes to understand the code
3. Check out the different screens and features
4. Read the main README.md for more detailed information

---

**Happy Coding! 🚀**

If you have any questions, feel free to reach out to the development team. 