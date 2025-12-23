# Zero Signal

A comprehensive location-based mobile application built with Flutter that enables users to discover, share, and navigate to various spots and routes. The app features interactive mapping, social features, and personalized content management.

## 🚀 Features

### Core Functionality
- **Interactive Map Integration**: Powered by Mapbox Maps for real-time navigation and location discovery
- **Location-Based Services**: Find nearby spots, restaurants, parks, landmarks, and more
- **Route Management**: Create, save, and share custom routes with detailed information
- **Spot Discovery**: Explore and bookmark favorite locations with detailed information
- **Social Features**: Connect with other users, share spots, and engage with the community
- **User Authentication**: Secure sign-up and login system with OTP verification

### Advanced Features
- **Multi-Language Support**: Choose from multiple languages for better accessibility
- **Offline Downloads**: Manage downloaded maps and content for offline use
- **Advanced Filtering**: Filter spots and routes by various criteria
- **Profile Management**: Complete user profile with personal information management
- **Activity Tracking**: Create and manage activities related to locations
- **Real-Time Chat**: In-app messaging and communication features
- **Responsive Design**: Optimized for various screen sizes using Flutter ScreenUtil

## 📱 Screens & Modules

### Authentication Flow
- Splash Screen & Onboarding
- Language Selection
- Sign In / Sign Up with OTP verification
- Password Reset functionality

### Main Navigation
- **Home Screen**: Interactive map with search and filtering
- **My Spots**: Personal collection of saved locations
- **My Routes**: Custom route creation and management
- **Social Screen**: Community interaction and sharing
- **Profile**: User settings and personal information

### Additional Features
- Spot Details & Information
- Route Planning & Navigation
- Filter & Search functionality
- Download Management
- Settings & Preferences
- Help & Support

## 🛠 Tech Stack

### Framework & Language
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language

### State Management & Architecture
- **GetX**: State management, dependency injection, and navigation
- **Repository Pattern**: Clean architecture for data management
- **Controller Pattern**: Separation of business logic from UI

### Key Dependencies
- **mapbox_maps_flutter**: Interactive mapping and navigation
- **geolocator**: Location services and GPS tracking
- **dio**: HTTP client for API communication
- **shared_preferences**: Local data persistence
- **flutter_screenutil**: Responsive design utilities
- **google_nav_bar**: Modern navigation bar
- **table_calendar**: Calendar integration
- **image_picker**: Camera and gallery access
- **google_fonts**: Typography and font management

### UI/UX Components
- **flutter_otp_text_field**: OTP input fields
- **pin_code_fields**: PIN code entry
- **fluttertoast**: User notifications
- **flutter_html**: Rich text content display

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── my_app.dart              # Root app widget configuration
├── constant/                # App constants (colors, icons, etc.)
├── routes/                  # Navigation and routing configuration
├── screen/                  # UI screens and components
│   ├── auth/               # Authentication screens
│   ├── home_screen/        # Main map and discovery
│   ├── my_spots_screen/    # Personal spots management
│   ├── my_routes_screen/   # Route creation and management
│   ├── profile/            # User profile and settings
│   └── ...                 # Additional feature screens
├── repository/             # Data layer and API services
├── service/                # Business logic services
├── widget/                 # Reusable UI components
└── utils/                  # Utility functions and helpers
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.4.1)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Mapbox API access token

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zero_signal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Mapbox**
   - Replace the Mapbox access token in `lib/main.dart` with your own
   - Get your token from [Mapbox Dashboard](https://account.mapbox.com/)

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **FVM Setup** (if using Flutter Version Management)
   ```bash
   fvm use stable
   fvm flutter pub get
   ```

2. **Code Generation**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

## 🗺 Mapbox Configuration

The app uses Mapbox for mapping services. To configure:

1. Create a Mapbox account at [mapbox.com](https://www.mapbox.com/)
2. Generate an access token
3. Update the token in `lib/main.dart`:
   ```dart
   MapboxOptions.setAccessToken("YOUR_ACCESS_TOKEN_HERE");
   ```

## 📱 Platform Support

- **Android**: Minimum SDK 21 (Android 5.0)
- **iOS**: iOS 11.0 and above
- **Web**: Supported (with some limitations)

## 🎨 Design System

The app follows a modern design approach with:
- **Responsive Design**: Using Flutter ScreenUtil for consistent UI across devices
- **Material Design**: Google's Material Design principles
- **Custom Components**: Reusable widgets for consistent UI
- **Color Scheme**: Consistent color palette defined in constants

## 🔧 Configuration Files

- `.fvmrc`: Flutter version configuration
- `analysis_options.yaml`: Dart/Flutter linting rules
- `pubspec.yaml`: Dependencies and project metadata
- `.env`: Environment variables (not included in repository)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Code Style

The project follows Flutter/Dart best practices:
- Use `flutter_lints` for code quality
- Follow repository pattern for data management
- Implement proper error handling
- Use GetX for state management and navigation
- Maintain clean folder structure

## 🐛 Known Issues

- Map rendering may be slow on older devices
- Offline maps require significant storage space
- Some features may require internet connectivity

## 📄 License

This project is private and not published to pub.dev. All rights reserved.

## 📞 Support

For support and inquiries:
- Check the in-app help section
- Contact support through the app
- Report issues via the project repository

---

**Zero Signal** - Your companion for discovering and sharing amazing locations! 🗺️✨
