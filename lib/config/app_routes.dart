import 'package:flutter/material.dart';
import '../initial_pages/auth/splash_screen.dart';
import '../initial_pages/auth/phone_input_screen.dart';
import '../initial_pages/auth/otp_screen.dart';
import '../initial_pages/main/home_screen.dart';
import '../initial_pages/main/registration_screen.dart';
import '../test/phase1_test_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String phoneInput = '/phone-input';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String registration = '/registration';
  static const String phase1Test = '/phase1-test';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      phoneInput: (context) => const PhoneInputScreen(),
      otp: (context) {
        final modalRoute = ModalRoute.of(context);
        final args =
            modalRoute?.settings.arguments as Map<String, dynamic>? ?? {};
        final phoneNumber = args['phoneNumber'] ?? '';
        final verificationId = args['verificationId'] ?? '';
        final userExists = args['userExists'] as bool?;
        return OtpScreen(
          phoneNumber: phoneNumber,
          verificationId: verificationId,
          userExists: userExists,
        );
      },
      home: (context) => const HomeScreen(),
      registration: (context) {
        final modalRoute = ModalRoute.of(context);
        final args =
            modalRoute?.settings.arguments as Map<String, dynamic>? ?? {};
        final phoneNumber = args['phoneNumber'] ?? '';
        return RegistrationScreen(phoneNumber: phoneNumber);
      },
      phase1Test: (context) => const Phase1TestScreen(),
    };
  }
}
