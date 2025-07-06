import '../services/college_service.dart';

class CollegeInitializer {
  static final CollegeService _collegeService = CollegeService();

  // Call this method to initialize sample colleges
  static Future<void> initializeSampleColleges() async {
    try {
      // Add more dummy colleges
      await _collegeService.initializeSampleColleges();
      await _collegeService.addPendingCollege('Springfield University');
      await _collegeService.addPendingCollege('Riverdale College of Arts');
      await _collegeService.addPendingCollege(
        'Starlight Institute of Technology',
      );
      await _collegeService.addPendingCollege('Greenfield Polytechnic');
      await _collegeService.addPendingCollege('Sunrise Business School');
      print('Sample colleges initialized successfully!');
    } catch (e) {
      print('Failed to initialize sample colleges: $e');
    }
  }
}
