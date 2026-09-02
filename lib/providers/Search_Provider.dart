import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class SearchProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Result> searchResults = [];
  bool isLoading = false;
  String? error;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      error = null;
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await _movieService.searchMovies(query);
      
      searchResults = results.where((movie) {
        final title = movie.title ?? '';
        return title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
    } catch (e) {
      error = e.toString();
      searchResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}