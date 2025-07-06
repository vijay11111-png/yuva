import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_routes.dart';
import 'config/colors.dart';
import 'initial_pages/widgets/auth_wrapper.dart';
import 'initial_pages/services/service_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yuva',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {'/': (context) => const AuthWrapper(), ...AppRoutes.getRoutes()},
      initialBinding: BindingsBuilder(() {
        // Initialize non-critical services in background with delay
        Future.delayed(const Duration(seconds: 2), () {
          ServiceManager().initializeNonCriticalServices();
        });
      }),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonEnabled,
            foregroundColor: AppColors.buttonTextEnabled,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.textLight,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonEnabled,
            foregroundColor: AppColors.buttonTextEnabled,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textLight),
          bodyMedium: TextStyle(color: AppColors.textLight),
        ),
      ),
    );
  }
}
