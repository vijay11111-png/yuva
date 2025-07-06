class UserRegistrationModel {
  // Step 1: Personal Information
  String? fullName;
  DateTime? dateOfBirth;
  String? gender; // 'M', 'F', 'Other'
  String? street;
  String? city;
  double? latitude;
  double? longitude;

  // Step 2: Academic Information (to be implemented)
  String? college;
  String? course;
  int? yearOfStudy;
  String? collegeIdImagePath; // Path to the uploaded college ID image

  // Step 3: Interests (to be implemented)
  List<String>? interests;

  // Common fields
  String? phoneNumber;
  String? userId;
  bool isProfileComplete;

  UserRegistrationModel({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.street,
    this.city,
    this.latitude,
    this.longitude,
    this.college,
    this.course,
    this.yearOfStudy,
    this.collegeIdImagePath,
    this.interests,
    this.phoneNumber,
    this.userId,
    this.isProfileComplete = false,
  });

  // Check if step 1 is complete
  bool get isStep1Complete {
    return fullName != null &&
        fullName!.isNotEmpty &&
        dateOfBirth != null &&
        gender != null &&
        gender!.isNotEmpty &&
        street != null &&
        street!.isNotEmpty &&
        city != null &&
        city!.isNotEmpty;
  }

  // Check if step 2 is complete
  bool get isStep2Complete {
    return college != null &&
        college!.isNotEmpty &&
        course != null &&
        course!.isNotEmpty &&
        yearOfStudy != null &&
        collegeIdImagePath != null &&
        collegeIdImagePath!.isNotEmpty;
  }

  // Check if step 3 is complete
  bool get isStep3Complete {
    return interests != null && interests!.isNotEmpty;
  }

  // Check if all steps are complete
  bool get isAllStepsComplete {
    return isStep1Complete && isStep2Complete && isStep3Complete;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'street': street,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'college': college,
      'course': course,
      'yearOfStudy': yearOfStudy,
      'collegeIdImagePath': collegeIdImagePath,
      'interests': interests,
      'phoneNumber': phoneNumber,
      'isProfileComplete': isAllStepsComplete,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Create from Map
  factory UserRegistrationModel.fromMap(Map<String, dynamic> map) {
    return UserRegistrationModel(
      fullName: map['fullName'],
      dateOfBirth:
          map['dateOfBirth'] != null
              ? DateTime.parse(map['dateOfBirth'])
              : null,
      gender: map['gender'],
      street: map['street'],
      city: map['city'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      college: map['college'],
      course: map['course'],
      yearOfStudy: map['yearOfStudy'],
      collegeIdImagePath: map['collegeIdImagePath'],
      interests: List<String>.from(map['interests'] ?? []),
      phoneNumber: map['phoneNumber'],
      userId: map['userId'],
      isProfileComplete: map['isProfileComplete'] ?? false,
    );
  }

  // Copy with method
  UserRegistrationModel copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? street,
    String? city,
    double? latitude,
    double? longitude,
    String? college,
    String? course,
    int? yearOfStudy,
    String? collegeIdImagePath,
    List<String>? interests,
    String? phoneNumber,
    String? userId,
    bool? isProfileComplete,
  }) {
    return UserRegistrationModel(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      street: street ?? this.street,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      college: college ?? this.college,
      course: course ?? this.course,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      collegeIdImagePath: collegeIdImagePath ?? this.collegeIdImagePath,
      interests: interests ?? this.interests,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userId: userId ?? this.userId,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
