import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseInitialization();
  }

  Future<void> _checkFirebaseInitialization() async {
    // Wait a bit for Firebase to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      // Try to access Firebase Auth to check if it's initialized
      FirebaseAuth.instance;
      if (mounted) {
        setState(() {
          _isFirebaseInitialized = true;
        });
      }
    } catch (e) {
      // Firebase not ready yet, try again
      if (mounted) {
        Future.delayed(
          const Duration(milliseconds: 500),
          _checkFirebaseInitialization,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while Firebase is initializing
    if (!_isFirebaseInitialized) {
      return const SplashScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // User is authenticated, go to home
        if (snapshot.hasData && snapshot.data != null) {
          return const SplashScreen(); // This will navigate to home after splash
        }

        // User is not authenticated, go to phone input
        return const SplashScreen(); // This will navigate to phone input after splash
      },
    );
  }
}
