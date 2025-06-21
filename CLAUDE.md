# InTruth Onboarding Flutter Web App

## Project Overview
This is a Flutter web application that provides an onboarding experience for the "InTruth" platform. The app features a multi-page onboarding flow with dark theme, smooth animations, and PWA capabilities.

## Project Structure
```
intruth_onboarding/
├── lib/                          # Main Dart source code
│   ├── main.dart                 # App entry point
│   └── onboarding/               # Onboarding feature module
│       ├── controllers/          # State management controllers
│       ├── models/              # Data models
│       ├── screens/             # UI screens
│       └── widgets/             # Reusable UI components
├── web/                         # Web-specific files
├── assets/                      # Static assets (images, etc.)
├── test/                        # Unit and widget tests
├── pubspec.yaml                 # Dependencies and metadata
├── analysis_options.yaml       # Dart analyzer configuration
├── vercel-build.sh             # Deployment script for Vercel
└── README.md                   # Project documentation
```

## Key Technical Details

### Dependencies
- Flutter SDK with Dart >=3.4.3 <4.0.0
- Flutter version 3.22.2 (specified in build script)
- Material 3 design with cupertino_icons
- flutter_lints for code quality

### Architecture
- **Pattern**: MVC-like with Flutter's reactive pattern
- **State Management**: ChangeNotifier (built-in Flutter)
- **Structure**: Feature-based modular architecture
- **Navigation**: Route-based with callback handlers

### Key Features
- 3-page onboarding flow ("Welcome to InTruth", "Share Your Truth", "Build Connections")
- Dark theme implementation
- Page indicators and skip functionality
- PWA support with manifest.json
- Responsive design for web

### Build & Deployment
- **Build command**: `flutter build web`
- **Deployment**: Configured for Vercel via vercel-build.sh
- **Testing**: Use `flutter test` for unit/widget tests
- **Linting**: Enabled via flutter_lints package

### Important Files
- `lib/main.dart`: App entry point with theme and routing
- `lib/onboarding/onboarding_flow.dart`: Main flow configuration
- `lib/onboarding/controllers/onboarding_controller.dart`: State management
- `lib/onboarding/screens/onboarding_screen.dart`: Main UI screen
- `web/index.html`: Web entry point
- `web/manifest.json`: PWA configuration

## Development Notes
- Follow Flutter/Dart conventions as configured in analysis_options.yaml
- Use existing state management pattern (ChangeNotifier)
- Maintain feature-based directory structure
- Test changes with `flutter test` before deployment