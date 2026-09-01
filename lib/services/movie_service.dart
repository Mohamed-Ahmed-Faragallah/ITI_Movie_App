import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  Future<List<Result>> getMovies() async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=f5b77ece23ef64ae6cf1ee9722b67020",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final movieModel = movieModelFromJson(response.body);
      return movieModel.results;
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
