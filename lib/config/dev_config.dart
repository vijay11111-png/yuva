import 'package:firebase_auth/firebase_auth.dart';

class DevConfig {
  // Enable testing features for development
  static void enableTestingFeatures() {
    // Enable app verification disabled for testing (Android only)
    // This allows testing with fictional phone numbers
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  }

  // Test phone numbers for development
  static const String testPhoneNumber = '+16505554567';
  static const String testOtpCode = '123456';

  // Configure auto-retrieval for testing
  static void configureAutoRetrieval() {
    // Note: autoRetrievedSmsCodeForPhoneNumber is not available in Flutter Firebase Auth
    // This is only available in native Android implementation
    // For Flutter, we use appVerificationDisabledForTesting for testing
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  }

  // Check if we're in development mode
  static bool get isDevelopment {
    // You can add more sophisticated logic here
    // For now, we'll assume development mode
    return true;
  }
}
