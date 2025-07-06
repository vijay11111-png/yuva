import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'config/dev_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start the app immediately without waiting for Firebase
  runApp(const MyApp());

  // Initialize Firebase in background after app starts
  _initializeFirebaseInBackground();
}

Future<void> _initializeFirebaseInBackground() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable testing features for development
    if (DevConfig.isDevelopment) {
      DevConfig.enableTestingFeatures();
    }
  } catch (e) {
    // Handle Firebase initialization errors gracefully
    debugPrint('Firebase initialization failed: $e');
  }
}
