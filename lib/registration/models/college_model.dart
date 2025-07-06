import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeModel {
  final String id;
  final String name;
  final String? location;
  final String? district;
  final String? state;
  final List<String> courses;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  CollegeModel({
    required this.id,
    required this.name,
    this.location,
    this.district,
    this.state,
    required this.courses,
    this.isVerified = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'district': district,
      'state': state,
      'courses': courses,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory CollegeModel.fromJson(Map<String, dynamic> json, String documentId) {
    return CollegeModel(
      id: documentId,
      name: json['name'] ?? '',
      location: json['location'],
      district: json['district'],
      state: json['state'],
      courses: List<String>.from(json['courses'] ?? []),
      isVerified: json['isVerified'] ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Get full location string
  String get fullLocation {
    List<String> parts = [];
    if (location != null && location!.isNotEmpty) parts.add(location!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    return parts.join(', ');
  }

  // Create a copy with updated fields
  CollegeModel copyWith({
    String? id,
    String? name,
    String? location,
    String? district,
    String? state,
    List<String>? courses,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollegeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      district: district ?? this.district,
      state: state ?? this.state,
      courses: courses ?? this.courses,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'CollegeModel(id: $id, name: $name, location: $fullLocation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CollegeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
