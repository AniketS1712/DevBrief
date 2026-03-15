import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';
import '../models/repo.dart';
import '../models/article.dart';
import '../widgets/repo_card.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookmarkService _bookmarkService = BookmarkService();
  List<Repo> _repos = [];
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final repos = await _bookmarkService.getBookmarkedRepos();
    final articles = await _bookmarkService.getBookmarkedArticles();
    if (mounted) {
      setState(() {
        _repos = repos;
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.code), text: 'Repositories'),
              Tab(icon: Icon(Icons.article), text: 'Articles'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Repositories Tab
                RefreshIndicator(
                  onRefresh: _loadBookmarks,
                  child: _repos.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text('No saved repositories.')),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _repos.length,
                          itemBuilder: (context, index) {
                            return RepoCard(repo: _repos[index]);
                          },
                        ),
                ),
                // Articles Tab
                RefreshIndicator(
                  onRefresh: _loadBookmarks,
                  child: _articles.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text('No saved articles.')),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            return ArticleCard(article: _articles[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
