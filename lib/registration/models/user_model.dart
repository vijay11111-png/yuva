import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String location;
  final String college;
  final String currentYear;
  final String? course;
  final String? idCardUrl;
  final String? profilePictureUrl;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isProfileComplete;

  UserModel({
    this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.location,
    required this.college,
    required this.currentYear,
    this.course,
    this.idCardUrl,
    this.profilePictureUrl,
    required this.interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isProfileComplete = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Check if user is at least 13 years old
  bool get isEligible => age >= 13;

  // Convert to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'location': location,
      'college': college,
      'currentYear': currentYear,
      'course': course,
      'idCardUrl': idCardUrl,
      'profilePictureUrl': profilePictureUrl,
      'interests': interests,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isProfileComplete': isProfileComplete,
    };
  }

  // Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      fullName: json['fullName'] ?? '',
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      college: json['college'] ?? '',
      currentYear: json['currentYear'] ?? '',
      course: json['course'],
      idCardUrl: json['idCardUrl'],
      profilePictureUrl: json['profilePictureUrl'],
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    String? college,
    String? currentYear,
    String? course,
    String? idCardUrl,
    String? profilePictureUrl,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isProfileComplete,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      college: college ?? this.college,
      currentYear: currentYear ?? this.currentYear,
      course: course ?? this.course,
      idCardUrl: idCardUrl ?? this.idCardUrl,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, age: $age, college: $college)';
  }
}
