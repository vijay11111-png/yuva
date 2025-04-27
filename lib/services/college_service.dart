import 'package:yuva/models/college.dart'; // Verify this path

class CollegeService {
  final List<College> _colleges = [College('1', 'Yuva University'), College('2', 'Tech College')];

  void fetchColleges() async {
    // Simulate API call
    // _colleges = await http.get(Uri.parse('https://api.example.com/colleges')).then((response) => parseResponse(response.body));
  }

  List<College> getSuggestions(String input) {
    return _colleges.where((college) {
      return college.name != null && college.name!.toLowerCase().contains(input.toLowerCase());
    }).toList();
  }

  void joinCollegeClub(String? collegeId) {
    if (collegeId != null) {
      // Logic to join club
      print('Joined club for college ID: $collegeId');
    }
  }

  void notifyAdmin(String collegeName) {
    // Logic to notify admin
    print('Notified admin about new college: $collegeName');
  }
}