# Firebase Phone Authentication Setup Guide

This guide will help you set up Firebase Phone Authentication for your Flutter app.

## Prerequisites

1. A Firebase project
2. Flutter SDK installed
3. Android Studio or VS Code
4. Physical device or emulator for testing

## Firebase Project Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select an existing project
3. Follow the setup wizard

### 2. Enable Billing (CRITICAL STEP)

**⚠️ IMPORTANT: You MUST enable billing for Phone Authentication to work!**

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Click on **Usage and billing** tab
3. Click **Modify plan**
4. Select **Blaze (Pay as you go)** plan
5. Add a payment method (credit card required)
6. **Note**: You get $0.01 per SMS for phone verification, but Firebase provides free tier credits

### 3. Enable Required APIs

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/library)
2. Select your Firebase project (`theyuvaapp`)
3. Enable the following APIs:
   - **Cloud Firestore API** (required for database operations)
   - **Firebase Authentication API** (should be auto-enabled)
   - **Identity and Access Management (IAM) API**

### 4. Add Android App

1. In Firebase Console, click the Android icon to add an Android app
2. Enter your package name (found in `android/app/build.gradle.kts`)
3. Download the `google-services.json` file
4. Place it in `android/app/` directory

### 5. Enable Phone Authentication

1. In Firebase Console, go to **Authentication > Sign-in method**
2. Enable "Phone" as a sign-in provider
3. Add test phone numbers for development:
   - Phone: `+16505554567`
   - Code: `123456`

### 6. Configure SHA-1 Certificate (for production)

For production apps, you need to add your app's SHA-1 certificate:

```bash
# Debug certificate
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release certificate (if you have one)
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

Add the SHA-1 fingerprint to your Firebase project settings.

## Flutter Setup

### 1. Dependencies

The following dependencies are already added to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.13.0
  sms_autofill: ^2.3.0
```

### 2. Android Configuration

Update `android/app/build.gradle.kts`:

```kotlin
android {
    namespace = "com.example.yuva"
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.example.yuva"
        minSdk = 21  // Required for Firebase Auth
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
}
```

### 3. iOS Configuration (if needed)

For iOS, you'll need to:
1. Add iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Add it to your iOS project

## Testing

### Development Testing

The app is configured for development testing with:

- Test phone number: `+16505554567`
- Test OTP code: `123456`
- App verification disabled for testing

### Testing Flow

1. Enter the test phone number: `+16505554567`
2. Tap "Next" to send OTP
3. Enter the test OTP: `123456`
4. You should be redirected to the home screen

### Real Device Testing

For testing on real devices:

1. Use a real phone number
2. You'll receive actual SMS with OTP
3. Enter the received OTP code

## Features Implemented

### 1. Phone Input Screen
- Phone number validation
- Country code (+91) prefix
- Loading states
- Error handling

### 2. OTP Verification Screen
- 6-digit OTP input
- Auto-focus and keyboard handling
- Resend functionality with timer
- Error handling and validation

### 3. Authentication Service
- Firebase Phone Auth integration
- Error handling for common scenarios
- Auto-verification support (Android)
- Session management

### 4. Home Screen
- User information display
- Sign out functionality
- Authentication state management

### 5. Auth Wrapper
- Automatic navigation based on auth state
- Persistent login sessions

## Error Handling

The app handles common Firebase Auth errors:

- `invalid-phone-number`: Invalid phone format
- `too-many-requests`: Rate limiting
- `quota-exceeded`: SMS quota exceeded
- `invalid-verification-code`: Wrong OTP
- `session-expired`: Verification timeout
- `billing-not-enabled`: Billing not enabled (requires Blaze plan)

## Production Considerations

### 1. Disable Testing Features

Before releasing to production:

```dart
// In lib/config/dev_config.dart
static bool get isDevelopment {
  return false; // or use environment variables
}
```

### 2. Add Real Phone Numbers

Remove test phone numbers and use real ones for production.

### 3. Security Rules

Set up proper Firebase Security Rules for your database.

### 4. App Store Compliance

Ensure your app complies with app store guidelines for phone authentication.

## Troubleshooting

### Common Issues

1. **"BILLING_NOT_ENABLED"**
   - **Solution**: Enable Blaze (pay-as-you-go) plan in Firebase Console
   - Go to Project Settings > Usage and billing > Modify plan

2. **"Cloud Firestore API has not been used"**
   - **Solution**: Enable Firestore API in Google Cloud Console
   - Visit: https://console.cloud.google.com/apis/api/firestore.googleapis.com/overview?project=theyuvaapp

3. **"Invalid phone number"**
   - Check phone number format
   - Ensure country code is correct

4. **"SMS not received"**
   - Check Firebase Console settings
   - Verify phone number is added to test numbers
   - Check device network connection

5. **"App verification failed"**
   - Ensure SHA-1 certificate is added to Firebase
   - Check if testing features are properly configured

6. **Google Play Services errors**
   - Ensure Google Play Services is up to date on test device
   - Check if device has proper Google account setup

### Debug Mode

Enable debug logging:

```dart
// Add to main.dart
import 'package:firebase_core/firebase_core.dart';
```

## Cost Considerations

- **Phone Authentication**: $0.01 per SMS (but you get free tier credits)
- **Firestore**: Free tier includes 50,000 reads, 20,000 writes, 20,000 deletes per day
- **Storage**: Free tier includes 5GB storage

For development and small apps, you'll likely stay within the free tier limits.

## Support

For more information, refer to:
- [Firebase Phone Auth Documentation](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [Flutter Firebase Auth Package](https://pub.dev/packages/firebase_auth)
- [Firebase Console](https://console.firebase.google.com/) 