import 'package:cloud_firestore/cloud_firestore.dart';
import 'error_handler.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if user exists by phone number
  Future<bool> isUserExists(String phoneNumber) async {
    return ErrorHandler.safeAsyncOperation<bool>(
      () async {
        // Format phone number with country code
        final formattedPhone =
            phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

        final QuerySnapshot doc =
            await _firestore
                .collection('users')
                .where('phoneNumber', isEqualTo: formattedPhone)
                .limit(1)
                .get();

        final bool exists = doc.docs.isNotEmpty;
        return exists;
      },
      'UserService.isUserExists',
      fallbackValue: false,
    );
  }

  // Create new user
  Future<void> createUser({
    required String phoneNumber,
    required String name,
    required String email,
    String? profileImageUrl,
  }) async {
    return ErrorHandler.safeAsyncOperation<void>(() async {
      final formattedPhone =
          phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

      await _firestore.collection('users').add({
        'phoneNumber': formattedPhone,
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }, 'UserService.createUser');
  }

  // Get user by phone number
  Future<Map<String, dynamic>?> getUserByPhone(String phoneNumber) async {
    return ErrorHandler.safeAsyncOperation<Map<String, dynamic>?>(
      () async {
        final formattedPhone =
            phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

        final QuerySnapshot doc =
            await _firestore
                .collection('users')
                .where('phoneNumber', isEqualTo: formattedPhone)
                .limit(1)
                .get();

        if (doc.docs.isNotEmpty) {
          final userData = doc.docs.first.data() as Map<String, dynamic>?;
          return userData;
        }

        return null;
      },
      'UserService.getUserByPhone',
      fallbackValue: null,
    );
  }

  // Safe method to check user existence with multiple fallback strategies
  Future<bool> safeCheckUserExists(String phoneNumber) async {
    return ErrorHandler.safeAsyncOperation<bool>(
      () async {
        try {
          // Primary method: Direct Firestore query
          final exists = await isUserExists(phoneNumber);
          return exists;
        } catch (e) {
          try {
            // Fallback method: Try to get user data
            final userData = await getUserByPhone(phoneNumber);
            return userData != null;
          } catch (fallbackError) {
            // Final fallback: Allow registration if all checks fail
            return false;
          }
        }
      },
      'UserService.safeCheckUserExists',
      fallbackValue: false,
    );
  }
}
