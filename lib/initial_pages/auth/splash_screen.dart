import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/colors.dart';
import '../../config/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start animation immediately
    _animationController.forward();

    // Check auth and navigate
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Reduced delay for faster startup
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.phoneInput);
        }
      } catch (e) {
        // Firebase not ready, try again
        Future.delayed(
          const Duration(milliseconds: 300),
          _checkAuthAndNavigate,
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flutter_dash,
                size: isSmallScreen ? 80 : 120,
                color: AppColors.textLight,
              ),
              SizedBox(height: isSmallScreen ? 20 : 30),
              Text(
                'YUVA',
                style: TextStyle(
                  fontSize: isSmallScreen ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
