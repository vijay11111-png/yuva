import '../models/college_model.dart';

class DummyColleges {
  static List<CollegeModel> get colleges => [
    // Engineering Colleges
    CollegeModel(
      id: 'college_001',
      name: 'Indian Institute of Technology Bombay',
      location: 'Mumbai',
      district: 'Mumbai',
      state: 'Maharashtra',
      courses: [
        'Computer Science Engineering',
        'Mechanical Engineering',
        'Electrical Engineering',
        'Civil Engineering',
        'Chemical Engineering',
        'Aerospace Engineering',
      ],
    ),
    CollegeModel(
      id: 'college_002',
      name: 'Delhi Technological University',
      location: 'Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: [
        'Computer Science Engineering',
        'Information Technology',
        'Mechanical Engineering',
        'Electrical Engineering',
        'Civil Engineering',
        'Biotechnology',
      ],
    ),
    CollegeModel(
      id: 'college_003',
      name: 'Vellore Institute of Technology',
      location: 'Vellore',
      district: 'Vellore',
      state: 'Tamil Nadu',
      courses: [
        'Computer Science Engineering',
        'Information Technology',
        'Mechanical Engineering',
        'Electrical Engineering',
        'Civil Engineering',
        'Biomedical Engineering',
      ],
    ),

    // Medical Colleges
    CollegeModel(
      id: 'college_004',
      name: 'All India Institute of Medical Sciences',
      location: 'New Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: ['MBBS', 'BDS', 'BSc Nursing', 'BSc Medical Technology'],
    ),
    CollegeModel(
      id: 'college_005',
      name: 'Christian Medical College',
      location: 'Vellore',
      district: 'Vellore',
      state: 'Tamil Nadu',
      courses: [
        'MBBS',
        'BDS',
        'BSc Nursing',
        'BSc Medical Technology',
        'BSc Physiotherapy',
      ],
    ),

    // Arts and Science Colleges
    CollegeModel(
      id: 'college_006',
      name: 'St. Xavier\'s College',
      location: 'Mumbai',
      district: 'Mumbai',
      state: 'Maharashtra',
      courses: [
        'Bachelor of Arts',
        'Bachelor of Science',
        'Bachelor of Commerce',
        'Bachelor of Management Studies',
      ],
    ),
    CollegeModel(
      id: 'college_007',
      name: 'Lady Shri Ram College for Women',
      location: 'Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: [
        'Bachelor of Arts',
        'Bachelor of Science',
        'Bachelor of Commerce',
        'Bachelor of Elementary Education',
      ],
    ),

    // Business Schools
    CollegeModel(
      id: 'college_008',
      name: 'Indian Institute of Management Ahmedabad',
      location: 'Ahmedabad',
      district: 'Ahmedabad',
      state: 'Gujarat',
      courses: ['MBA', 'PGP', 'FPM', 'PGPX'],
    ),
    CollegeModel(
      id: 'college_009',
      name: 'Xavier School of Management',
      location: 'Jamshedpur',
      district: 'East Singhbhum',
      state: 'Jharkhand',
      courses: ['MBA', 'PGDM', 'PGP', 'FPM'],
    ),

    // Law Colleges
    CollegeModel(
      id: 'college_010',
      name: 'National Law School of India University',
      location: 'Bangalore',
      district: 'Bangalore Urban',
      state: 'Karnataka',
      courses: ['BA LLB', 'BBA LLB', 'LLM', 'PhD in Law'],
    ),
    CollegeModel(
      id: 'college_011',
      name: 'National Law University Delhi',
      location: 'Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: ['BA LLB', 'BBA LLB', 'LLM', 'PhD in Law'],
    ),

    // Design and Architecture
    CollegeModel(
      id: 'college_012',
      name: 'National Institute of Design',
      location: 'Ahmedabad',
      district: 'Ahmedabad',
      state: 'Gujarat',
      courses: ['Bachelor of Design', 'Master of Design', 'Diploma in Design'],
    ),
    CollegeModel(
      id: 'college_013',
      name: 'School of Planning and Architecture',
      location: 'Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: [
        'Bachelor of Architecture',
        'Bachelor of Planning',
        'Master of Architecture',
        'Master of Planning',
      ],
    ),

    // Agriculture Colleges
    CollegeModel(
      id: 'college_014',
      name: 'Indian Agricultural Research Institute',
      location: 'Delhi',
      district: 'New Delhi',
      state: 'Delhi',
      courses: ['BSc Agriculture', 'MSc Agriculture', 'PhD Agriculture'],
    ),

    // Pharmacy Colleges
    CollegeModel(
      id: 'college_015',
      name: 'National Institute of Pharmaceutical Education and Research',
      location: 'Mohali',
      district: 'SAS Nagar',
      state: 'Punjab',
      courses: ['BPharm', 'MPharm', 'PhD Pharmacy'],
    ),
  ];

  // Get colleges by state
  static List<CollegeModel> getCollegesByState(String state) {
    return colleges.where((college) => college.state == state).toList();
  }

  // Get colleges by location
  static List<CollegeModel> getCollegesByLocation(String location) {
    return colleges
        .where(
          (college) =>
              (college.location?.toLowerCase().contains(
                    location.toLowerCase(),
                  ) ??
                  false) ||
              (college.district?.toLowerCase().contains(
                    location.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  // Search colleges by name
  static List<CollegeModel> searchColleges(String query) {
    if (query.isEmpty) return [];

    return colleges
        .where(
          (college) =>
              college.name.toLowerCase().contains(query.toLowerCase()) ||
              (college.location?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (college.district?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (college.state?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
  }

  // Get all courses
  static List<String> getAllCourses() {
    Set<String> allCourses = {};
    for (var college in colleges) {
      allCourses.addAll(college.courses);
    }
    return allCourses.toList()..sort();
  }

  // Get courses by college
  static List<String> getCoursesByCollege(String collegeId) {
    final college = colleges.firstWhere(
      (c) => c.id == collegeId,
      orElse: () => CollegeModel(id: '', name: '', courses: []),
    );
    return college.courses;
  }
}
