import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';

class TrendingReposScreen extends StatefulWidget {
  const TrendingReposScreen({super.key});

  @override
  State<TrendingReposScreen> createState() => _TrendingReposScreenState();
}

class _TrendingReposScreenState extends State<TrendingReposScreen> {
  final ApiService _apiService = ApiService();
  List<Repo> _repos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Future<void> _fetchRepos() async {
    setState(() => _isLoading = true);
    try {
      final repos = await _apiService.getTrendingRepos();
      if (mounted) {
        setState(() {
          _repos = repos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading repositories: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_repos.isEmpty) {
      return const Center(child: Text('No trending repositories found.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchRepos,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _repos.length,
        itemBuilder: (context, index) {
          return RepoCard(repo: _repos[index]);
        },
      ),
    );
  }
}
