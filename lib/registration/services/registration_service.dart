import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_registration_model.dart';

class RegistrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user registration data to Firestore
  Future<String> saveUserRegistration(UserRegistrationModel userData) async {
    try {
      // Check if user already exists
      final QuerySnapshot existingUser =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: userData.phoneNumber)
              .limit(1)
              .get();

      String documentId;

      if (existingUser.docs.isNotEmpty) {
        // Update existing user
        documentId = existingUser.docs.first.id;
        await existingUser.docs.first.reference.update({
          ...userData.toMap(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        // Create new user
        final DocumentReference newUserRef = await _firestore
            .collection('users')
            .add(userData.toMap());
        documentId = newUserRef.id;
      }

      return documentId;
    } catch (e) {
      throw Exception('Failed to save user registration: $e');
    }
  }

  // Get user registration data by phone number
  Future<UserRegistrationModel?> getUserRegistration(String phoneNumber) async {
    try {
      final QuerySnapshot doc =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      if (doc.docs.isNotEmpty) {
        final userData = doc.docs.first.data() as Map<String, dynamic>;
        return UserRegistrationModel.fromMap({
          ...userData,
          'userId': doc.docs.first.id,
        });
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user registration: $e');
    }
  }

  // Update specific step of registration
  Future<void> updateRegistrationStep(
    String phoneNumber,
    Map<String, dynamic> stepData,
  ) async {
    try {
      final QuerySnapshot existingUser =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      if (existingUser.docs.isNotEmpty) {
        await existingUser.docs.first.reference.update({
          ...stepData,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to update registration step: $e');
    }
  }

  // Check if user exists
  Future<bool> isUserExists(String phoneNumber) async {
    try {
      final QuerySnapshot doc =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      return doc.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check user existence: $e');
    }
  }

  // Get user document ID by phone number
  Future<String?> getUserIdByPhone(String phoneNumber) async {
    try {
      final QuerySnapshot doc =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      if (doc.docs.isNotEmpty) {
        return doc.docs.first.id;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user ID: $e');
    }
  }
}
