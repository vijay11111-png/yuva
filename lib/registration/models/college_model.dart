class CollegeModel {
  final String id;
  final String name;
  final String? location;
  final String? type; // University, College, Institute, etc.
  final bool isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CollegeModel({
    required this.id,
    required this.name,
    this.location,
    this.type,
    this.isApproved = true,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'type': type,
      'isApproved': isApproved,
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Create from Map
  factory CollegeModel.fromMap(String id, Map<String, dynamic> map) {
    return CollegeModel(
      id: id,
      name: map['name'] ?? '',
      location: map['location'],
      type: map['type'],
      isApproved: map['isApproved'] ?? true,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Copy with method
  CollegeModel copyWith({
    String? id,
    String? name,
    String? location,
    String? type,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollegeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      type: type ?? this.type,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CollegeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
