import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/colors.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool? userExists; // Pre-checked user existence
  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.userExists,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  int _resendTimer = 30;
  bool _isResendEnabled = false;
  bool _isVerifying = false;
  bool _isAutoVerifying = false;
  Timer? _timer;
  String? _errorText;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpChanged() {
    setState(() {});
    if (_otpController.text.length == 6 && !_isVerifying && !_isAutoVerifying) {
      // Add a small delay to ensure the UI updates and prevent race conditions
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _otpController.text.length == 6) {
          _verifyOtp();
        }
      });
    }
  }

  void _startResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _resendTimer = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendTimer > 1) {
          _resendTimer--;
        } else {
          _isResendEnabled = true;
          _resendTimer = 0;
          _timer?.cancel();
        }
      });
    });
  }

  void _onResendPressed() async {
    if (_isResendEnabled && !_isVerifying && !_isAutoVerifying) {
      try {
        await _authService.sendOTP(
          phoneNumber: widget.phoneNumber,
          onCodeSent: (String verificationId) {
            // Update the verification ID for the new OTP
            // Note: In a real app, you might want to update the widget's verificationId
            _startResendTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP resent successfully'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onVerificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-verification completed (Android only)
            if (_isAutoVerifying) return; // Prevent multiple calls

            setState(() {
              _isAutoVerifying = true;
            });

            try {
              // Sign in with the auto-verification credential
              await _authService.signInWithCredential(credential);
              if (!mounted) return;

              // Navigate based on user existence
              await _navigateBasedOnUserExists();
            } catch (e) {
              if (mounted) {
                setState(() {
                  _errorText =
                      'Auto-verification failed. Please enter OTP manually.';
                  _isAutoVerifying = false;
                });
              }
            }
          },
          onVerificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(e.code)),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to resend OTP: ${e.toString()}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateBasedOnUserExists() async {
    if (!mounted) return;

    try {
      // Ensure user document exists in Firestore
      await _userService.ensureUserDocument(widget.phoneNumber);

      // Use pre-checked user existence for faster routing
      if (widget.userExists == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // New users go to registration
        Navigator.pushReplacementNamed(
          context,
          '/registration',
          arguments: {'phoneNumber': widget.phoneNumber},
        );
      }
    } catch (e) {
      // Fallback: Always go to registration if error occurs
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/registration',
          arguments: {'phoneNumber': widget.phoneNumber},
        );
      }
    }
  }

  void _verifyOtp() async {
    if (_isVerifying || _isAutoVerifying) return;

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    // Keep focus on the TextField during verification
    _otpFocusNode.requestFocus();

    try {
      // If already signed in (auto-verification), navigate directly
      if (_authService.currentUser != null) {
        await _navigateBasedOnUserExists();
        return;
      }

      final userCredential = await _authService.verifyOTP(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );

      if ((userCredential != null || _authService.currentUser != null) &&
          mounted) {
        await _navigateBasedOnUserExists();
        return;
      } else {
        if (mounted) {
          setState(() {
            _errorText = 'Verification failed. Please try again.';
            _otpController.clear();
          });
          _otpFocusNode.requestFocus();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = _getErrorMessage(e.code);
        _otpController.clear();
      });
      _otpFocusNode.requestFocus();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Verification failed. Please try again.\n${e.toString()}';
        _otpController.clear();
      });
      _otpFocusNode.requestFocus();
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return 'Invalid OTP. Please try again.';
      case 'invalid-verification-id':
        return 'Verification expired. Please request a new OTP.';
      case 'session-expired':
        return 'Session expired. Please try again.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Verification failed. Please try again.';
    }
  }

  Widget _buildOtpBoxes(BuildContext context) {
    final theme = Theme.of(context);
    final text = _otpController.text;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final isActive = text.length == i;
        final isFilled = i < text.length;
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2), // minimal gap
            child: GestureDetector(
              onTap: () => _otpFocusNode.requestFocus(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.ease,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accentPurpleLight : Colors.white,
                  border: Border.all(
                    color:
                        isActive
                            ? AppColors.primaryPurple
                            : AppColors.borderLight,
                    width: isActive ? 2.5 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      isActive
                          ? [
                            BoxShadow(
                              color: AppColors.primaryPurple.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                alignment: Alignment.center,
                child:
                    isFilled
                        ? (_isVerifying && i == 5
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryPurple,
                                ),
                              ),
                            )
                            : Text(
                              text[i],
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ))
                        : null,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 28,
            vertical: isSmallScreen ? 18 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isSmallScreen ? 32 : 56),
              // Heading
              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // Subheading with phone and change
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Sent to +91 ${widget.phoneNumber}',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Sign out if logged in, then pop
                      final navigatorContext = context;
                      try {
                        await _authService.signOut();
                      } catch (e) {
                        // Ignore sign out errors
                      }
                      if (mounted) {
                        Navigator.pop(navigatorContext);
                      }
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              // OTP boxes and hidden input
              Stack(
                alignment: Alignment.center,
                children: [
                  // Hidden TextField
                  Opacity(
                    opacity: 0,
                    child: TextField(
                      autofocus: true,
                      focusNode: _otpFocusNode,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSubmitted: (value) {
                        if (value.length == 6 &&
                            !_isVerifying &&
                            !_isAutoVerifying) {
                          _verifyOtp();
                        }
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  _buildOtpBoxes(context),
                ],
              ),
              const SizedBox(height: 24),
              // Manual submit button (backup)
              if (_otpController.text.length == 6 && !_isVerifying)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Error message
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 15,
                    ),
                  ),
                ),
              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _isResendEnabled ? _onResendPressed : null,
                    child: Text(
                      _isResendEnabled
                          ? 'Resend OTP'
                          : 'Resend in $_resendTimer s',
                      style: TextStyle(
                        color:
                            _isResendEnabled
                                ? AppColors.primaryPurple
                                : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Info text (optional)
              Text(
                'Didn\'t receive the code? Check your SMS or try again.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
