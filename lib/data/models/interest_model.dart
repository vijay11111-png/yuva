class InterestModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final int popularity;

  const InterestModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.popularity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'popularity': popularity,
    };
  }

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      popularity: json['popularity'] ?? 0,
    );
  }
}
