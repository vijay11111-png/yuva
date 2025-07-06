import 'package:cloud_firestore/cloud_firestore.dart';

class InterestModel {
  final String id;
  final String name;
  final String? category;
  final String? description;
  final int popularity;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  InterestModel({
    required this.id,
    required this.name,
    this.category,
    this.description,
    this.popularity = 0,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'popularity': popularity,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory InterestModel.fromJson(Map<String, dynamic> json, String documentId) {
    return InterestModel(
      id: documentId,
      name: json['name'] ?? '',
      category: json['category'],
      description: json['description'],
      popularity: json['popularity'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create a copy with updated fields
  InterestModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    int? popularity,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InterestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      popularity: popularity ?? this.popularity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'InterestModel(id: $id, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InterestModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
