import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieController {
  final MovieService service = MovieService();

  Future<List<Result>> getMovies() {
    return service.getMovies();
  }
}