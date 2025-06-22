# Bookavio

Your Trusted Platform

Bookavio is a Flutter-based booking application that provides users with
a seamless learning experience. The app features various categories, and functionalities, 
and a user-friendly interface for easy navigation.

## Features

- **Welcome Screen**: Engaging introductory screen/sliders to welcome users.
- **Home Screen**: Displays a calendar, different services categories and a search bar.
- **Services Screen**: Detailed services view with descriptions.
- **Chats screen**: Quick access to admins, using chats, video and audio calls.
- **Dashboard screen**: Shows recent activities and upcoming ones
- **Profile Screen**: Contains both personal & app information
- **Modern UI**: Clean and responsive design for a better user experience.

## Technologies Used

- Flutter
- Dart
- Material UI Components

## Prerequisites

Before you begin, ensure you have the following installed on your system:

### 1. Flutter SDK
- **Download Flutter**: Visit [flutter.dev](https://flutter.dev/docs/get-started/install) and download the Flutter SDK for your operating system
- **Extract**: Extract the downloaded file to a location on your computer (e.g., `C:\flutter` on Windows, `/Users/username/flutter` on macOS, `/home/username/flutter` on Linux)
- **Add to PATH**: Add Flutter to your system PATH environment variable
- **Verify Installation**: Open terminal/command prompt and run:
  ```bash
  flutter doctor
  ```

### 2. Dart SDK
- Flutter comes with Dart SDK, so no separate installation is needed

### 3. IDE (Choose one)
- **VS Code** (Recommended): Download from [code.visualstudio.com](https://code.visualstudio.com/)
  - Install Flutter and Dart extensions
- **Android Studio**: Download from [developer.android.com](https://developer.android.com/studio)
  - Install Flutter and Dart plugins

### 4. Git
- Download and install Git from [git-scm.com](https://git-scm.com/)

## Installation Steps

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/bookavio.git
cd bookavio
```

### Step 2: Check Flutter Installation
```bash
flutter doctor
```
This command will check your Flutter installation and tell you if anything is missing. Make sure all checks pass (✓).

### Step 3: Get Dependencies
```bash
flutter pub get
```

### Step 4: Run the App

#### For Web (Easiest to start with):
```bash
flutter run -d chrome
```

#### For Android:
1. **Set up Android Studio**:
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Install Android SDK (API level 21 or higher)
   - Create an Android Virtual Device (AVD) or connect a physical device

2. **Run on Android**:
   ```bash
   flutter run -d android
   ```

#### For iOS (macOS only):
1. **Install Xcode** from the Mac App Store
2. **Install iOS Simulator** or connect a physical iOS device
3. **Run on iOS**:
   ```bash
   flutter run -d ios
   ```

#### For Windows:
```bash
flutter run -d windows
```

#### For macOS:
```bash
flutter run -d macos
```

#### For Linux:
```bash
flutter run -d linux
```

## Project Structure

```
bookavio/
├── lib/
│   ├── main.dart                 # Entry point of the app
│   ├── models/                   # Data models
│   ├── pages/                    # UI pages/screens
│   ├── screens/                  # Additional screens
│   ├── services/                 # Business logic and services
│   └── widgets/                  # Reusable UI components
├── assets/                       # Images, fonts, and other assets
├── android/                      # Android-specific configurations
├── ios/                          # iOS-specific configurations
├── web/                          # Web-specific configurations
├── windows/                      # Windows-specific configurations
├── macos/                        # macOS-specific configurations
├── linux/                        # Linux-specific configurations
└── pubspec.yaml                  # Dependencies and project configuration
```

## Dependencies

The project uses the following main dependencies:
- `camera: ^0.10.5+9` - For camera functionality
- `agora_rtc_engine: ^6.2.6` - For video/audio calls
- `connectivity_plus: ^5.0.2` - For network connectivity
- `google_sign_in: ^6.1.5` - For Google authentication
- `table_calendar: ^3.0.9` - For calendar functionality
- `file_picker: ^10.2.0` - For file selection
- `audioplayers: ^6.5.0` - For audio playback
- `image_picker: ^1.1.2` - For image selection

## Troubleshooting

### Common Issues and Solutions:

1. **Flutter doctor shows issues**:
   - Follow the instructions provided by `flutter doctor`
   - Install missing components (Android SDK, Xcode, etc.)

2. **Dependencies not found**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build errors**:
   - Check if all dependencies are compatible
   - Update Flutter to the latest stable version
   - Run `flutter doctor` to identify issues

4. **Android build issues**:
   - Make sure Android SDK is properly installed
   - Check that ANDROID_HOME environment variable is set
   - Update Android SDK tools

5. **iOS build issues (macOS only)**:
   - Make sure Xcode is installed and updated
   - Accept Xcode license: `sudo xcodebuild -license accept`
   - Install iOS Simulator

6. **Permission issues**:
   - For camera and microphone access, ensure proper permissions are set in platform-specific files

## Development Guidelines

1. **Code Style**: Follow Dart/Flutter conventions
2. **State Management**: Use Provider pattern for state management
3. **UI Components**: Use Material Design components
4. **Testing**: Write unit and widget tests for critical functionality

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Commit your changes: `git commit -m 'Add feature'`
5. Push to the branch: `git push origin feature-name`
6. Submit a pull request

## Support

If you encounter any issues during installation or development:
1. Check the troubleshooting section above
2. Search for similar issues on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
3. Create an issue in the GitHub repository

## License

This project is licensed under the MIT License - see the LICENSE file for details.

 