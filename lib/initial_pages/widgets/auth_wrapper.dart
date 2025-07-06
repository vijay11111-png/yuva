import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/splash_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
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
