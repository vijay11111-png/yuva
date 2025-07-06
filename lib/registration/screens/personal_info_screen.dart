import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/colors.dart';
import '../models/user_registration_model.dart';
import '../services/location_service.dart';
import '../controllers/registration_controller.dart';
import '../widgets/progress_indicator_widget.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String phoneNumber;
  final UserRegistrationModel? existingData;

  const PersonalInfoScreen({
    super.key,
    required this.phoneNumber,
    this.existingData,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isLoadingLocation = false;
  bool _isLoading = false;
  bool _isLocationEditable = false;
  String? _locationStreet;
  String? _locationCity;

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    if (widget.existingData != null) {
      _fullNameController.text = widget.existingData!.fullName ?? '';
      _selectedDate = widget.existingData!.dateOfBirth;
      _selectedGender = widget.existingData!.gender;
      _locationStreet = widget.existingData!.street;
      _locationCity = widget.existingData!.city;
      _updateLocationDisplay();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 years ago
      lastDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateLocationDisplay() {
    if (_locationStreet != null && _locationCity != null) {
      _locationController.text = '$_locationStreet, $_locationCity';
    } else if (_locationStreet != null) {
      _locationController.text = _locationStreet!;
    } else if (_locationCity != null) {
      _locationController.text = _locationCity!;
    } else {
      _locationController.text = '';
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final locationData =
          await _locationService.getCurrentLocationWithAddress();

      setState(() {
        _locationStreet = locationData['street'] ?? '';
        _locationCity = locationData['city'] ?? '';
        _updateLocationDisplay();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location detected successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLocationEditable = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detection failed. You can enter manually.'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  bool _isFormValid() {
    return _fullNameController.text.trim().isNotEmpty &&
        _selectedDate != null &&
        _selectedGender != null &&
        _locationController.text.trim().isNotEmpty;
  }

  Widget _buildGenderOption({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryPurple.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPurple : color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected
                        ? AppColors.primaryPurple
                        : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToNextStep() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update the registration controller with step 1 data
      final registrationController = RegistrationController();
      registrationController.initialize(widget.phoneNumber);

      // Parse location into street and city
      final locationText = _locationController.text.trim();
      String? street, city;

      if (locationText.contains(',')) {
        final parts = locationText.split(',');
        street = parts[0].trim();
        city = parts.length > 1 ? parts[1].trim() : null;
      } else {
        // If no comma, treat as city
        city = locationText;
      }

      registrationController.updateStep1Data(
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
        street: street,
        city: city,
      );

      // Save the data
      final success = await registrationController.saveCurrentStep();

      if (success && mounted) {
        // Navigate to step 2
        final registrationController = RegistrationController();
        registrationController.initialize(widget.phoneNumber);
        registrationController.nextStep();

        Navigator.pushReplacementNamed(
          context,
          '/registration',
          arguments: {'phoneNumber': widget.phoneNumber},
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save data. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            const RegistrationProgressIndicator(currentStep: 1),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date of Birth Field
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'Select your date of birth',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                              : 'Select Date',
                          style: TextStyle(
                            color:
                                _selectedDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gender Selection
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildGenderOption(
                              value: 'M',
                              icon: Icons.male,
                              label: 'Male',
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.borderLight,
                          ),
                          Expanded(
                            child: _buildGenderOption(
                              value: 'F',
                              icon: Icons.female,
                              label: 'Female',
                              color: Colors.pink,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.borderLight,
                          ),
                          Expanded(
                            child: _buildGenderOption(
                              value: 'Other',
                              icon: Icons.person,
                              label: 'Other',
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location Field
                    TextFormField(
                      controller: _locationController,
                      enabled:
                          _isLocationEditable ||
                          _locationController.text.isEmpty,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        hintText:
                            'Tap location icon to auto-detect or enter manually',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon:
                            _isLoadingLocation
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryPurple,
                                      ),
                                    ),
                                  ),
                                )
                                : IconButton(
                                  icon: const Icon(Icons.my_location),
                                  onPressed: _getCurrentLocation,
                                  tooltip: 'Auto-detect location',
                                ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid() ? _proceedToNextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Next Step',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
