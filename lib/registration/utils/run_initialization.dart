import 'initialize_colleges.dart';
import 'initialize_courses.dart';

class DataInitializer {
  static Future<void> initializeAllData() async {
    print('Starting data initialization...');

    try {
      // Initialize colleges
      print('Initializing colleges...');
      await CollegeInitializer.initializeSampleColleges();

      // Initialize courses
      print('Initializing courses...');
      await CourseInitializer.initializeSampleCourses();

      print('All data initialized successfully!');
      print(
        'Colleges: ~100+ Indian colleges including IITs, NITs, BITS, and major universities',
      );
      print(
        'Courses: ~200+ courses including engineering, science, arts, and specialized programs',
      );
    } catch (e) {
      print('Failed to initialize data: $e');
    }
  }
}
