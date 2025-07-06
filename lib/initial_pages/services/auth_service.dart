import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Send OTP to phone number with optimized timeout
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    try {
      // Format phone number with country code
      final formattedPhone =
          phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) {
          try {
            onVerificationCompleted(credential);
          } catch (e) {
            // Handle callback error silently
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          try {
            onVerificationFailed(e);
          } catch (callbackError) {
            // Handle callback error silently
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          try {
            onCodeSent(verificationId);
          } catch (e) {
            // Handle callback error silently
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed
        },
        timeout: const Duration(seconds: 30), // Reduced from 60 to 30 seconds
      );
    } catch (e) {
      try {
        onVerificationFailed(
          FirebaseAuthException(code: 'unknown', message: e.toString()),
        );
      } catch (callbackError) {
        // Handle callback error silently
      }
    }
  }

  // Verify OTP with better error handling
  Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      // Validate inputs
      if (verificationId.isEmpty || smsCode.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-argument',
          message: 'Verification ID and SMS code cannot be empty',
        );
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await _auth.signInWithCredential(credential);
      return result;
    } catch (e) {
      // Handle Firebase Auth Pigeon type casting error specifically
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('List<Object?>') ||
          e.toString().contains('is not a subtype of type')) {
        // Check if the user is actually signed in despite the error
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          // Return null to indicate success but let the caller handle the navigation
          // The user is actually authenticated, so we can proceed
          return null;
        }
      }

      rethrow;
    }
  }

  // Sign in with credential (for auto-verification)
  Future<UserCredential> signInWithCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      // Validate credential
      if (credential.verificationId == null || credential.smsCode == null) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid phone auth credential',
        );
      }

      final result = await _auth.signInWithCredential(credential);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    try {
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  // Get user phone number
  String? get userPhoneNumber {
    try {
      return _auth.currentUser?.phoneNumber;
    } catch (e) {
      return null;
    }
  }

  // Safe method to get current user with error handling
  User? getSafeCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }
}
