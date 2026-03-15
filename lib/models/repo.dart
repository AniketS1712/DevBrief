class Repo {
  final String id;
  final String name;
  final String description;
  final String ownerName;
  final int stars;
  final String? language;
  final String url;

  Repo({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerName,
    required this.stars,
    this.language,
    required this.url,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ownerName: json['owner']?['login'] ?? '',
      stars: json['stargazers_count'] ?? 0,
      language: json['language'],
      url: json['html_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner': {'login': ownerName},
      'stargazers_count': stars,
      'language': language,
      'html_url': url,
    };
  }
}
