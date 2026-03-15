import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isBookmarked = false;
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final status = await _bookmarkService.isArticleBookmarked(
      widget.article.id,
    );
    if (mounted) {
      setState(() {
        _isBookmarked = status;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await _bookmarkService.removeArticle(widget.article.id);
    } else {
      await _bookmarkService.saveArticle(widget.article);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse(widget.article.url);
    if (await canLaunchUrl(url)) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showErrorSnackBar('Could not launch ${widget.article.url}');
      }
    } else {
      _showErrorSnackBar('Invalid URL or no browser found: ${widget.article.url}');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.deepPurple.shade100),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _launchUrl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.coverImage != null)
              Image.network(
                widget.article.coverImage!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 150, color: Colors.deepPurple.shade200),
              ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              height: 2,
              color: Colors.deepPurple.shade100,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.article.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.blue : null,
                        ),
                        onPressed: _toggleBookmark,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.article.authorName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.article.readingTimeMinutes} min read',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
