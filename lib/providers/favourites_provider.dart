import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class FavouritesProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Map<String, dynamic>> favourites = [];

  Future<void> loadFavourites() async {
    favourites = await _dbHelper.getFavourites();
    notifyListeners();
  }

  Future<void> addFavourite(Map<String, dynamic> movie) async {
    await _dbHelper.addFavourite(movie);
    await loadFavourites();
  }

  Future<void> removeFavourite(int id) async {
    await _dbHelper.removeFavourite(id);
    await loadFavourites();
  }

  bool isFavourite(int id) {
    return favourites.any((movie) => movie['id'] == id);
  }
}