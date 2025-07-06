import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../controllers/registration_controller.dart';
import '../models/user_registration_model.dart';
import '../widgets/progress_indicator_widget.dart';
import 'personal_info_screen.dart';
import 'academic_info_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;

  const RegistrationScreen({super.key, required this.phoneNumber});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegistrationController();
    _controller.initialize(widget.phoneNumber);
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    await _controller.loadExistingData(widget.phoneNumber);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCurrentStep() {
    switch (_controller.currentStep) {
      case 1:
        return PersonalInfoScreen(
          phoneNumber: widget.phoneNumber,
          existingData: _controller.userData,
        );
      case 2:
        return AcademicInfoScreen(
          phoneNumber: widget.phoneNumber,
          existingData: _controller.userData,
        );
      case 3:
        return _buildPlaceholderStep(
          'Interests',
          'Step 3: Select Your Interests',
          'This step will be implemented next',
        );
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget _buildPlaceholderStep(String title, String subtitle, String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _controller.previousStep(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          RegistrationProgressIndicator(currentStep: _controller.currentStep),

          // Content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 80,
                      color: AppColors.primaryPurple.withOpacity(0.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_controller.canGoBack())
                          ElevatedButton(
                            onPressed: () => _controller.previousStep(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Previous'),
                          ),
                        ElevatedButton(
                          onPressed:
                              _controller.currentStep < 3
                                  ? () => _controller.nextStep()
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            _controller.currentStep < 3 ? 'Next' : 'Complete',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (_controller.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _controller.errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _controller.clearError();
                        _loadExistingData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _buildCurrentStep();
      },
    );
  }
}
