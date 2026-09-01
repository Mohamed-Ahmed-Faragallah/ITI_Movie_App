import 'package:flutter/foundation.dart';
import '../controllers/movie_controller.dart';
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  final MovieController controller = MovieController();

  bool isLoading = false;
  String? error;

  List<Result> movies = [];

  Future<void> getMovies() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      movies = await controller.getMovies();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}