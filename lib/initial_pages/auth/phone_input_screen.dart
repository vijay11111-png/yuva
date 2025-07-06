import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/colors.dart';
import '../../config/app_routes.dart';
import '../services/auth_service.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
    // Auto-focus the phone input field to open numeric keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if user is already signed in
      final user = _authService.currentUser;
      if (user != null && mounted) {
        // User is already signed in, navigate to home
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    setState(() {
      _isButtonEnabled = _phoneController.text.length == 10;
    });
  }

  void _onNextPressed() async {
    if (_isButtonEnabled && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Send OTP immediately without checking user existence first
        await _authService.sendOTP(
          phoneNumber: _phoneController.text,
          onCodeSent: (String verificationId) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.otp,
              arguments: {
                'phoneNumber': _phoneController.text,
                'verificationId': verificationId,
                'userExists': false, // Will be checked in OTP screen if needed
              },
            );
          },
          onVerificationCompleted: (PhoneAuthCredential credential) async {
            try {
              // Sign in with the auto-verification credential
              await _authService.signInWithCredential(credential);
              if (!mounted) return;

              // Navigate to home after successful auto-verification
              Navigator.pushReplacementNamed(context, '/home');
            } catch (e) {
              if (!mounted) return;
              setState(() {
                _isLoading = false;
              });
              _showErrorSnackBar('Auto-verification failed: ${e.toString()}');
            }
          },
          onVerificationFailed: (FirebaseAuthException e) {
            setState(() {
              _isLoading = false;
            });
            _showErrorSnackBar(_getErrorMessage(e.code));
          },
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to send OTP: ${e.toString()}');
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Failed to send OTP. Please try again';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, // 6% of screen width
            vertical: 24.0,
          ),
          child: Column(
            children: [
              // Logo and YUVA name at the top
              SizedBox(height: isSmallScreen ? 20 : 40),
              Center(
                child: Column(
                  children: [
                    // Logo placeholder (you can replace with actual logo)
                    Container(
                      width: isSmallScreen ? 60 : 80,
                      height: isSmallScreen ? 60 : 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 15 : 20,
                        ),
                      ),
                      child: Icon(
                        Icons.phone_android,
                        size: isSmallScreen ? 30 : 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      'YUVA',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28 : 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Centered content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your phone number',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'We\'ll send you a verification code',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  // Phone input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Country code prefix
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Phone number input
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 32 : 40),
                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isButtonEnabled && !_isLoading
                              ? _onNextPressed
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isButtonEnabled && !_isLoading
                                ? AppColors.buttonEnabled
                                : AppColors.buttonDisabled,
                        foregroundColor:
                            _isButtonEnabled && !_isLoading
                                ? AppColors.buttonTextEnabled
                                : AppColors.buttonTextDisabled,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 14 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.buttonTextEnabled,
                                  ),
                                ),
                              )
                              : Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
