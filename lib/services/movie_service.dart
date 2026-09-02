import 'dart:convert';
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

  Future<List<String>> getMovieGenres(int movieId) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/movie/$movieId?api_key=f5b77ece23ef64ae6cf1ee9722b67020",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List genresJson = data['genres'];
      return genresJson.map((g) => g['name'].toString()).toList();
    } else {
      throw Exception("Failed to load movie details");
    }
  }

  Future<List<Result>> searchMovies(String query) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/search/movie?api_key=f5b77ece23ef64ae6cf1ee9722b67020&query=$query&language=en-US&page=1&include_adult=false",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List resultsJson = data['results'] ?? [];

      List<Result> validMovies = [];
      for (var x in resultsJson) {
        try {
          if (x['poster_path'] != null &&
              x['backdrop_path'] != null &&
              x['overview'] != null &&
              x['release_date'] != null &&
              x['original_title'] != null) {
            validMovies.add(Result.fromJson(x));
          }
        } catch (_) {}
      }
      return validMovies;
    } else {
      throw Exception("Failed to search movies");
    }
  }
}