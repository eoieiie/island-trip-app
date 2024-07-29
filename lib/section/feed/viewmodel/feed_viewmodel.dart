/* import 'package:flutter/material.dart';
import '../model/feed.dart';
import '../repository/feed_repository.dart';

class FeedViewModel extends ChangeNotifier {
  final FeedRepository _feedRepository = FeedRepository();
  List<Feed> _feeds = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Feed> get feeds => _feeds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFeeds() async {
    _isLoading = true;
    notifyListeners();

    try {
      _feeds = await _feedRepository.fetchFeeds();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadFeed(Feed feed) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _feedRepository.uploadFeed(feed);
      _feeds.add(feed);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
*/