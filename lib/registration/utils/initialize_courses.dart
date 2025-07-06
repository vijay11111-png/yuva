import '../services/course_service.dart';

class CourseInitializer {
  static final CourseService _courseService = CourseService();

  static Future<void> initializeSampleCourses() async {
    try {
      await _courseService.initializeSampleCourses();
      await _courseService.addPendingCourse('Astrophysics');
      await _courseService.addPendingCourse('Marine Biology');
      await _courseService.addPendingCourse('Game Design');
      await _courseService.addPendingCourse('Culinary Arts');
      await _courseService.addPendingCourse('Robotics Engineering');
      print('Sample courses initialized successfully!');
    } catch (e) {
      print('Failed to initialize sample courses: $e');
    }
  }
}
