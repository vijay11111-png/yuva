import 'models/interest_model.dart';

class DummyInterests {
  static List<InterestModel> get interests => [
    // Technology
    InterestModel(
      id: 'interest_001',
      name: 'Technology',
      category: 'Technology',
      description: 'Latest tech trends and innovations',
      popularity: 95,
    ),
    InterestModel(
      id: 'interest_002',
      name: 'Programming',
      category: 'Technology',
      description: 'Coding and software development',
      popularity: 88,
    ),
    InterestModel(
      id: 'interest_003',
      name: 'Artificial Intelligence',
      category: 'Technology',
      description: 'AI and machine learning',
      popularity: 82,
    ),
    InterestModel(
      id: 'interest_004',
      name: 'Mobile Apps',
      category: 'Technology',
      description: 'Mobile application development',
      popularity: 75,
    ),

    // Sports
    InterestModel(
      id: 'interest_005',
      name: 'Cricket',
      category: 'Sports',
      description: 'Cricket and related activities',
      popularity: 90,
    ),
    InterestModel(
      id: 'interest_006',
      name: 'Football',
      category: 'Sports',
      description: 'Football and soccer',
      popularity: 85,
    ),
    InterestModel(
      id: 'interest_007',
      name: 'Basketball',
      category: 'Sports',
      description: 'Basketball and related sports',
      popularity: 70,
    ),
    InterestModel(
      id: 'interest_008',
      name: 'Fitness',
      category: 'Sports',
      description: 'Health and fitness',
      popularity: 78,
    ),

    // Music
    InterestModel(
      id: 'interest_009',
      name: 'Music',
      category: 'Entertainment',
      description: 'Music and musical instruments',
      popularity: 92,
    ),
    InterestModel(
      id: 'interest_010',
      name: 'Singing',
      category: 'Entertainment',
      description: 'Vocal music and singing',
      popularity: 80,
    ),
    InterestModel(
      id: 'interest_011',
      name: 'Guitar',
      category: 'Entertainment',
      description: 'Guitar playing and music',
      popularity: 72,
    ),

    // Arts
    InterestModel(
      id: 'interest_012',
      name: 'Photography',
      category: 'Arts',
      description: 'Photography and visual arts',
      popularity: 68,
    ),
    InterestModel(
      id: 'interest_013',
      name: 'Painting',
      category: 'Arts',
      description: 'Painting and drawing',
      popularity: 65,
    ),
    InterestModel(
      id: 'interest_014',
      name: 'Design',
      category: 'Arts',
      description: 'Graphic design and creativity',
      popularity: 73,
    ),

    // Reading
    InterestModel(
      id: 'interest_015',
      name: 'Reading',
      category: 'Education',
      description: 'Books and literature',
      popularity: 85,
    ),
    InterestModel(
      id: 'interest_016',
      name: 'Writing',
      category: 'Education',
      description: 'Creative writing and blogging',
      popularity: 70,
    ),

    // Travel
    InterestModel(
      id: 'interest_017',
      name: 'Travel',
      category: 'Lifestyle',
      description: 'Travel and exploration',
      popularity: 88,
    ),
    InterestModel(
      id: 'interest_018',
      name: 'Adventure',
      category: 'Lifestyle',
      description: 'Adventure sports and activities',
      popularity: 75,
    ),

    // Food
    InterestModel(
      id: 'interest_019',
      name: 'Cooking',
      category: 'Lifestyle',
      description: 'Cooking and culinary arts',
      popularity: 82,
    ),
    InterestModel(
      id: 'interest_020',
      name: 'Food',
      category: 'Lifestyle',
      description: 'Food and dining',
      popularity: 90,
    ),

    // Gaming
    InterestModel(
      id: 'interest_021',
      name: 'Gaming',
      category: 'Entertainment',
      description: 'Video games and gaming',
      popularity: 87,
    ),
    InterestModel(
      id: 'interest_022',
      name: 'Esports',
      category: 'Entertainment',
      description: 'Competitive gaming',
      popularity: 73,
    ),

    // Business
    InterestModel(
      id: 'interest_023',
      name: 'Entrepreneurship',
      category: 'Business',
      description: 'Business and startups',
      popularity: 78,
    ),
    InterestModel(
      id: 'interest_024',
      name: 'Finance',
      category: 'Business',
      description: 'Finance and investment',
      popularity: 72,
    ),

    // Science
    InterestModel(
      id: 'interest_025',
      name: 'Science',
      category: 'Education',
      description: 'Scientific research and discovery',
      popularity: 68,
    ),
    InterestModel(
      id: 'interest_026',
      name: 'Space',
      category: 'Education',
      description: 'Space exploration and astronomy',
      popularity: 75,
    ),

    // Social Causes
    InterestModel(
      id: 'interest_027',
      name: 'Environment',
      category: 'Social',
      description: 'Environmental conservation',
      popularity: 80,
    ),
    InterestModel(
      id: 'interest_028',
      name: 'Social Work',
      category: 'Social',
      description: 'Community service and social work',
      popularity: 70,
    ),

    // Fashion
    InterestModel(
      id: 'interest_029',
      name: 'Fashion',
      category: 'Lifestyle',
      description: 'Fashion and style',
      popularity: 85,
    ),
    InterestModel(
      id: 'interest_030',
      name: 'Beauty',
      category: 'Lifestyle',
      description: 'Beauty and cosmetics',
      popularity: 78,
    ),
  ];

  // Get interests by category
  static List<InterestModel> getInterestsByCategory(String category) {
    return interests
        .where((interest) => interest.category == category)
        .toList();
  }

  // Search interests by name
  static List<InterestModel> searchInterests(String query) {
    if (query.isEmpty) return [];

    return interests
        .where(
          (interest) =>
              interest.name.toLowerCase().contains(query.toLowerCase()) ||
              (interest.category?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (interest.description?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  // Get popular interests (top 10 by popularity)
  static List<InterestModel> getPopularInterests() {
    final sortedInterests = List<InterestModel>.from(interests);
    sortedInterests.sort((a, b) => b.popularity.compareTo(a.popularity));
    return sortedInterests.take(10).toList();
  }

  // Get all categories
  static List<String> getAllCategories() {
    Set<String> categories = {};
    for (var interest in interests) {
      if (interest.category != null) {
        categories.add(interest.category!);
      }
    }
    return categories.toList()..sort();
  }

  // Get interests by popularity range
  static List<InterestModel> getInterestsByPopularityRange(
    int minPopularity,
    int maxPopularity,
  ) {
    return interests
        .where(
          (interest) =>
              interest.popularity >= minPopularity &&
              interest.popularity <= maxPopularity,
        )
        .toList();
  }
}
