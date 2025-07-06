import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class RegistrationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Offline storage key
  static const String _offlineDataKey = 'registration_offline_data';
  static const String _pendingUploadsKey = 'registration_pending_uploads';

  // Observable variables
  final RxBool isOnline = true.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
  }

  // Check if user is connected to internet
  void _checkConnectivity() {
    // This will be enhanced with connectivity_plus in later phases
    isOnline.value = true; // Placeholder
  }

  // Save user data to Firestore
  Future<bool> saveUserData(UserModel user) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(user.toJson());

      // Clear offline data if save was successful
      await _clearOfflineData();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save user data: ${e.toString()}';

      // Save to offline storage if online save fails
      await _saveOfflineData(user);

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to get user data: ${e.toString()}';
      return null;
    }
  }

  // Check if user profile is complete
  Future<bool> isProfileComplete(String userId) async {
    try {
      final UserModel? user = await getUserData(userId);
      return user?.isProfileComplete ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save data to offline storage
  Future<void> _saveOfflineData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = user.toJson();
      await prefs.setString(_offlineDataKey, jsonEncode(userData));
    } catch (e) {
      print('Failed to save offline data: $e');
    }
  }

  // Get data from offline storage
  Future<UserModel?> getOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_offlineDataKey);

      if (userDataString != null) {
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        return UserModel.fromJson(userData, 'offline');
      }
      return null;
    } catch (e) {
      print('Failed to get offline data: $e');
      return null;
    }
  }

  // Clear offline data
  Future<void> _clearOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_offlineDataKey);
    } catch (e) {
      print('Failed to clear offline data: $e');
    }
  }

  // Sync offline data when back online
  Future<bool> syncOfflineData() async {
    try {
      if (!isOnline.value) return false;

      final UserModel? offlineUser = await getOfflineData();
      if (offlineUser != null) {
        final success = await saveUserData(offlineUser);
        if (success) {
          await _clearOfflineData();
        }
        return success;
      }
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to sync offline data: ${e.toString()}';
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      await _firestore.collection('users').doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // Delete user account
  Future<bool> deleteUserAccount(String userId) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      // Delete from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Delete user authentication
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }

      // Clear offline data
      await _clearOfflineData();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete account: ${e.toString()}';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // Get registration statistics
  Future<Map<String, dynamic>> getRegistrationStats() async {
    try {
      final QuerySnapshot usersSnapshot =
          await _firestore.collection('users').get();

      final int totalUsers = usersSnapshot.docs.length;
      final int completedProfiles =
          usersSnapshot.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data?['isProfileComplete'] == true;
          }).length;

      return {
        'totalUsers': totalUsers,
        'completedProfiles': completedProfiles,
        'completionRate':
            totalUsers > 0 ? (completedProfiles / totalUsers) * 100 : 0,
      };
    } catch (e) {
      errorMessage.value = 'Failed to get statistics: ${e.toString()}';
      return {'totalUsers': 0, 'completedProfiles': 0, 'completionRate': 0};
    }
  }

  // Validate user data before saving
  bool validateUserData(UserModel user) {
    if (user.fullName.isEmpty || user.fullName.length < 2) {
      errorMessage.value = 'Full name must be at least 2 characters';
      return false;
    }

    if (!user.isEligible) {
      errorMessage.value = 'User must be at least 13 years old';
      return false;
    }

    if (user.gender.isEmpty) {
      errorMessage.value = 'Gender is required';
      return false;
    }

    if (user.location.isEmpty) {
      errorMessage.value = 'Location is required';
      return false;
    }

    if (user.college.isEmpty) {
      errorMessage.value = 'College is required';
      return false;
    }

    if (user.currentYear.isEmpty) {
      errorMessage.value = 'Current year is required';
      return false;
    }

    if (user.interests.isEmpty) {
      errorMessage.value = 'At least one interest is required';
      return false;
    }

    if (user.interests.length > 5) {
      errorMessage.value = 'Maximum 5 interests allowed';
      return false;
    }

    return true;
  }
}
