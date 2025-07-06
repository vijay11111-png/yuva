class CollegeModel {
  final String id;
  final String name;
  final String? location;
  final String? district;
  final String? state;
  final List<String> courses;

  const CollegeModel({
    required this.id,
    required this.name,
    this.location,
    this.district,
    this.state,
    required this.courses,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'district': district,
      'state': state,
      'courses': courses,
    };
  }

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'],
      district: json['district'],
      state: json['state'],
      courses: List<String>.from(json['courses'] ?? []),
    );
  }
}
