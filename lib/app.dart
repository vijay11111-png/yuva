import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_routes.dart';
import 'config/colors.dart';
import 'initial_pages/widgets/auth_wrapper.dart';
import 'services/registration_service.dart';
import 'services/storage_service.dart';
import 'services/location_service.dart';
import 'services/analytics_service.dart';

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
        // Initialize all services
        Get.put(RegistrationService());
        Get.put(StorageService());
        Get.put(LocationService());
        Get.put(AnalyticsService());
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
