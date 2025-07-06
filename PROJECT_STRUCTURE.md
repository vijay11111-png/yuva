# YUVA Project Structure

This document outlines the reorganized and cleaned up project structure for the YUVA Flutter application.

## Project Overview

YUVA is a Flutter application with Firebase Phone Authentication that follows a clean, organized structure with proper separation of concerns.

## Directory Structure

```
lib/
├── main.dart                 # Application entry point
├── app.dart                  # Main app widget with theme configuration
├── firebase_options.dart     # Firebase configuration
├── config/                   # Configuration files
│   ├── app_routes.dart       # Route definitions and navigation
│   ├── colors.dart           # App color scheme
│   ├── constants.dart        # App constants
│   └── dev_config.dart       # Development configuration
├── initial_pages/            # All initial screens and main app screens
│   ├── auth/                 # Authentication-related screens
│   │   ├── splash_screen.dart
│   │   ├── phone_input_screen.dart
│   │   └── otp_screen.dart
│   └── main/                 # Main app screens (after authentication)
│       ├── home_screen.dart
│       └── registration_screen.dart
├── services/                 # Business logic and external services
│   ├── auth_service.dart     # Firebase authentication service
│   └── user_service.dart     # User data management service
└── widgets/                  # Reusable UI components
    └── auth_wrapper.dart     # Authentication state wrapper
```

## Screen Flow

1. **Splash Screen** (`auth/splash_screen.dart`)
   - Shows app logo and brand
   - Checks authentication state
   - Routes to appropriate screen based on auth status

2. **Phone Input Screen** (`auth/phone_input_screen.dart`)
   - Collects user phone number
   - Validates phone number format
   - Sends OTP via Firebase Auth

3. **OTP Screen** (`auth/otp_screen.dart`)
   - Displays 6-digit OTP input
   - Handles OTP verification
   - Routes to home or registration based on user existence

4. **Registration Screen** (`main/registration_screen.dart`)
   - Collects user profile information
   - Creates user account in Firestore
   - Routes to home screen after successful registration

5. **Home Screen** (`main/home_screen.dart`)
   - Main application screen
   - Displays user information
   - Provides logout functionality

## Key Features

### Authentication Flow
- Firebase Phone Authentication
- Automatic OTP verification (Android)
- User existence checking for faster routing
- Persistent login sessions

### Code Organization
- **Logical grouping**: Screens are organized by functionality (auth vs main)
- **Separation of concerns**: Services handle business logic, screens handle UI
- **Clean imports**: Proper relative imports throughout the project
- **Consistent naming**: Clear, descriptive file and class names

### Dependencies
The project uses only necessary dependencies:
- `firebase_core`: Firebase initialization
- `firebase_auth`: Phone authentication
- `cloud_firestore`: User data storage
- `cupertino_icons`: UI icons

### Removed Dependencies
The following unused dependencies were removed:
- `firebase_database`: Not used in the current implementation
- `firebase_storage`: Not used in the current implementation
- `sms_autofill`: Not used in the current implementation

## Configuration

### Firebase Setup
- Phone authentication enabled
- Firestore database for user data
- Test phone numbers configured for development

### Development Features
- Debug mode enabled for testing
- Test phone number: `+16505554567`
- Test OTP code: `123456`

## Best Practices Implemented

1. **Error Handling**: Comprehensive error handling throughout the app
2. **Loading States**: Proper loading indicators for async operations
3. **Form Validation**: Client-side validation for user inputs
4. **Responsive Design**: Adapts to different screen sizes
5. **Accessibility**: Proper focus management and keyboard handling
6. **State Management**: Clean state management with proper disposal

## Getting Started

1. Ensure Firebase project is configured
2. Run `flutter pub get` to install dependencies
3. Configure Firebase in your project
4. Run the app with `flutter run`

## Future Enhancements

- Add more main app screens
- Implement user profile management
- Add push notifications
- Implement offline support
- Add unit and widget tests 