import 'package:flutter/material.dart';
import '../../config/colors.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
            minHeight: 8,
          ),
          const SizedBox(height: 16),

          // Step indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      // Step circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isCompleted
                                  ? AppColors.primaryPurple
                                  : isCurrent
                                  ? AppColors.primaryPurple.withOpacity(0.8)
                                  : Colors.grey[300],
                          border:
                              isCurrent
                                  ? Border.all(
                                    color: AppColors.primaryPurple,
                                    width: 2,
                                  )
                                  : null,
                        ),
                        child: Center(
                          child:
                              isCompleted
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                  : Text(
                                    stepNumber.toString(),
                                    style: TextStyle(
                                      color:
                                          isCurrent
                                              ? Colors.white
                                              : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Step label
                      Text(
                        _getStepLabel(stepNumber),
                        style: TextStyle(
                          color:
                              isCompleted || isCurrent
                                  ? AppColors.primaryPurple
                                  : Colors.grey[600],
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 1:
        return 'Personal\nInfo';
      case 2:
        return 'Academic\nInfo';
      case 3:
        return 'Interests';
      default:
        return 'Step $step';
    }
  }
}
