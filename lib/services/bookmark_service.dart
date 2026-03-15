import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/repo.dart';
import '../models/article.dart';

class BookmarkService {
  static const String _reposKey = 'bookmarked_repos';
  static const String _articlesKey = 'bookmarked_articles';

  Future<List<Repo>> getBookmarkedRepos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList(_reposKey) ?? [];
    return items.map((e) => Repo.fromJson(json.decode(e))).toList();
  }

  Future<void> saveRepo(Repo repo) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getBookmarkedRepos();
    if (!items.any((item) => item.id == repo.id)) {
      items.add(repo);
      final jsonList = items.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList(_reposKey, jsonList);
    }
  }

  Future<void> removeRepo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getBookmarkedRepos();
    items.removeWhere((item) => item.id == id);
    final jsonList = items.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_reposKey, jsonList);
  }

  Future<bool> isRepoBookmarked(String id) async {
    final items = await getBookmarkedRepos();
    return items.any((item) => item.id == id);
  }

  Future<List<Article>> getBookmarkedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList(_articlesKey) ?? [];
    return items.map((e) => Article.fromJson(json.decode(e))).toList();
  }

  Future<void> saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getBookmarkedArticles();
    if (!items.any((item) => item.id == article.id)) {
      items.add(article);
      final jsonList = items.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList(_articlesKey, jsonList);
    }
  }

  Future<void> removeArticle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getBookmarkedArticles();
    items.removeWhere((item) => item.id == id);
    final jsonList = items.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_articlesKey, jsonList);
  }

  Future<bool> isArticleBookmarked(String id) async {
    final items = await getBookmarkedArticles();
    return items.any((item) => item.id == id);
  }
}
