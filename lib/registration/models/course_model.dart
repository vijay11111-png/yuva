class CourseModel {
  final String id;
  final String name;
  final bool isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseModel({
    required this.id,
    required this.name,
    this.isApproved = true,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isApproved': isApproved,
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      name: map['name'] ?? '',
      isApproved: map['isApproved'] ?? true,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  CourseModel copyWith({
    String? id,
    String? name,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CourseModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
