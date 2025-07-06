import 'package:flutter/material.dart';
import '../models/user_registration_model.dart';
import '../services/registration_service.dart';

class RegistrationController extends ChangeNotifier {
  final RegistrationService _registrationService = RegistrationService();

  UserRegistrationModel? _userData;
  int _currentStep = 1;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserRegistrationModel? get userData => _userData;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize with phone number
  void initialize(String phoneNumber) {
    _userData = UserRegistrationModel(phoneNumber: phoneNumber);
    _currentStep = 1;
    _errorMessage = null;
    notifyListeners();
  }

  // Update step 1 data
  void updateStep1Data({
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? street,
    String? city,
    double? latitude,
    double? longitude,
  }) {
    _userData = _userData?.copyWith(
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      street: street,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
    notifyListeners();
  }

  // Update step 2 data
  void updateStep2Data({
    String? college,
    String? course,
    int? yearOfStudy,
    String? collegeIdImagePath,
  }) {
    _userData = _userData?.copyWith(
      college: college,
      course: course,
      yearOfStudy: yearOfStudy,
      collegeIdImagePath: collegeIdImagePath,
    );
    notifyListeners();
  }

  // Update step 3 data
  void updateStep3Data({List<String>? interests}) {
    _userData = _userData?.copyWith(interests: interests);
    notifyListeners();
  }

  // Navigate to next step
  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Navigate to previous step
  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Go to specific step
  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      _currentStep = step;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Save current step data
  Future<bool> saveCurrentStep() async {
    if (_userData == null) return false;

    setLoading(true);
    try {
      await _registrationService.saveUserRegistration(_userData!);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to save data: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // Complete registration
  Future<bool> completeRegistration() async {
    if (_userData == null || !_userData!.isAllStepsComplete) {
      setError('Please complete all steps before finishing registration');
      return false;
    }

    setLoading(true);
    try {
      await _registrationService.saveUserRegistration(_userData!);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to complete registration: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  // Load existing user data
  Future<void> loadExistingData(String phoneNumber) async {
    setLoading(true);
    try {
      final existingData = await _registrationService.getUserRegistration(
        phoneNumber,
      );
      if (existingData != null) {
        _userData = existingData;

        // Determine current step based on completion
        if (existingData.isStep1Complete && !existingData.isStep2Complete) {
          _currentStep = 2;
        } else if (existingData.isStep2Complete &&
            !existingData.isStep3Complete) {
          _currentStep = 3;
        } else if (existingData.isAllStepsComplete) {
          _currentStep = 3; // Show last step if complete
        }
      }
      setLoading(false);
    } catch (e) {
      setError('Failed to load existing data: ${e.toString()}');
      setLoading(false);
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if current step is complete
  bool isCurrentStepComplete() {
    if (_userData == null) return false;

    switch (_currentStep) {
      case 1:
        return _userData!.isStep1Complete;
      case 2:
        return _userData!.isStep2Complete;
      case 3:
        return _userData!.isStep3Complete;
      default:
        return false;
    }
  }

  // Check if can proceed to next step
  bool canProceedToNextStep() {
    return isCurrentStepComplete();
  }

  // Check if can go back
  bool canGoBack() {
    return _currentStep > 1;
  }

  // Check if registration is complete
  bool isRegistrationComplete() {
    return _userData?.isAllStepsComplete ?? false;
  }

  // Reset registration
  void reset() {
    _userData = null;
    _currentStep = 1;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
