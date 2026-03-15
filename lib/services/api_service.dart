import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repo.dart';
import '../models/article.dart';
import '../models/quote.dart';

class ApiService {
  static const String _githubSearchUrl = 'https://api.github.com/search/repositories';
  static const String _devToUrl = 'https://dev.to/api/articles';
  static const String _quotableUrl = 'https://api.quotable.io/random';

  Future<List<Repo>> getTrendingRepos() async {
    // Fetch top starred repos created in the last 30 days
    final date = DateTime.now().subtract(const Duration(days: 30));
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    final response = await http.get(Uri.parse('$_githubSearchUrl?q=created:>$dateString&sort=stars&order=desc&per_page=15'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Repo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<List<Article>> getRecentArticles() async {
    final response = await http.get(Uri.parse('$_devToUrl?per_page=15'));

    if (response.statusCode == 200) {
      final List items = json.decode(response.body);
      return items.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<Quote> getDailyQuote() async {
    try {
      final response = await http.get(Uri.parse(_quotableUrl));
      if (response.statusCode == 200) {
        return Quote.fromJson(json.decode(response.body));
      } else {
        return _fallbackQuote();
      }
    } catch (e) {
      return _fallbackQuote();
    }
  }

  Quote _fallbackQuote() {
    return Quote(
      id: 'fallback',
      content: 'Code is like humor. When you have to explain it, it’s bad.',
      author: 'Cory House',
    );
  }
}
