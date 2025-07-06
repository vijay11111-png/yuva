import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/colors.dart';
import '../../config/app_routes.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('YUVA'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.textLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.phoneInput);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Welcome to YUVA!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Empowering Youth Through Connection',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Phone: ${user.phoneNumber ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),

            // Main Action Card
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryPurple.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person_add,
                        size: 60,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us about yourself to connect with like-minded youth',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement registration flow
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Registration feature coming soon!',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Start Registration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
