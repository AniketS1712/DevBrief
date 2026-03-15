import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/repo.dart';
import '../services/bookmark_service.dart';

class RepoCard extends StatefulWidget {
  final Repo repo;

  const RepoCard({super.key, required this.repo});

  @override
  State<RepoCard> createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  bool _isBookmarked = false;
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final status = await _bookmarkService.isRepoBookmarked(widget.repo.id);
    if (mounted) {
      setState(() {
        _isBookmarked = status;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await _bookmarkService.removeRepo(widget.repo.id);
    } else {
      await _bookmarkService.saveRepo(widget.repo);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse(widget.repo.url);
    if (await canLaunchUrl(url)) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showErrorSnackBar('Could not launch ${widget.repo.url}');
      }
    } else {
      _showErrorSnackBar('Invalid URL or no browser found: ${widget.repo.url}');
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
      child: InkWell(
        onTap: _launchUrl,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.repo.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade100,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: _isBookmarked ? Colors.deepPurple.shade100 : null,
                    ),
                    onPressed: _toggleBookmark,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (widget.repo.description.isNotEmpty) ...[
                Text(
                  widget.repo.description,
                  style: TextStyle(color: Colors.deepPurple.shade50),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    widget.repo.stars.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 32),
                  if (widget.repo.language != null &&
                      widget.repo.language!.isNotEmpty) ...[
                    Icon(
                      Icons.code,
                      size: 16,
                      color: Colors.deepPurple.shade50,
                    ),
                    const SizedBox(width: 4),
                    Text(widget.repo.language!),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.deepPurple.shade50,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.repo.ownerName,
                    style: TextStyle(color: Colors.deepPurple.shade50),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
