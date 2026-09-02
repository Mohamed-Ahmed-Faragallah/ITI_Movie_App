import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  DatabaseHelper._();
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favourites.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favourites(
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            voteAverage REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE user_movies(
            id INTEGER,
            title TEXT,
            poster_path TEXT,
            vote_average REAL,
            list_type TEXT,
            PRIMARY KEY (id, list_type)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS user_movies(
              id INTEGER,
              title TEXT,
              poster_path TEXT,
              vote_average REAL,
              list_type TEXT,
              PRIMARY KEY (id, list_type)
            )
          ''');
        }
      },
    );
  }

  Future<void> addFavourite(Map<String, dynamic> movie) async {
    final db = await database;
    await db.insert(
      'favourites',
      movie,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavourite(int id) async {
    final db = await database;
    await db.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavourites() async {
    final db = await database;
    return await db.query('favourites');
  }

  Future<void> addMovieToList(Map<String, dynamic> movieJson, String listType) async {
    final db = await database;
    await db.insert(
      'user_movies',
      {
        'id': movieJson['id'],
        'title': movieJson['title'],
        'poster_path': movieJson['poster_path'],
        'vote_average': movieJson['vote_average'],
        'list_type': listType,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeMovieFromList(int id, String listType) async {
    final db = await database;
    await db.delete(
      'user_movies',
      where: 'id = ? AND list_type = ?',
      whereArgs: [id, listType],
    );
  }

  Future<List<Map<String, dynamic>>> getMoviesByListType(String listType) async {
    final db = await database;
    return await db.query(
      'user_movies',
      where: 'list_type = ?',
      whereArgs: [listType],
    );
  }

  Future<bool> isMovieInList(int id, String listType) async {
    final db = await database;
    final result = await db.query(
      'user_movies',
      where: 'id = ? AND list_type = ?',
      whereArgs: [id, listType],
    );
    return result.isNotEmpty;
  }
}