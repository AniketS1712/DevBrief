class Article {
  final String id;
  final String title;
  final String url;
  final String? coverImage;
  final String authorName;
  final int readingTimeMinutes;

  Article({
    required this.id,
    required this.title,
    required this.url,
    this.coverImage,
    required this.authorName,
    required this.readingTimeMinutes,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      coverImage: json['cover_image'],
      authorName: json['user']?['name'] ?? json['user']?['username'] ?? '',
      readingTimeMinutes: json['reading_time_minutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? id,
      'title': title,
      'url': url,
      'cover_image': coverImage,
      'user': {'name': authorName},
      'reading_time_minutes': readingTimeMinutes,
    };
  }
}
