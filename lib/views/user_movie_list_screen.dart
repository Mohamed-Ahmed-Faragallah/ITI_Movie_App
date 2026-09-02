import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class UserMovieListScreen extends StatefulWidget {
  final String listType; 
  final String title;    

  const UserMovieListScreen({
    super.key,
    required this.listType,
    required this.title,
  });

  @override
  State<UserMovieListScreen> createState() => _UserMovieListScreenState();
}

class _UserMovieListScreenState extends State<UserMovieListScreen> {
  List<Map<String, dynamic>> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final loadedMovies = await DatabaseHelper.instance.getMoviesByListType(widget.listType);
    if (!mounted) return;
    setState(() {
      movies = loadedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF020617),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : movies.isEmpty
              ? Center(
                  child: Text(
                    'No movies in ${widget.title}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final item = movies[index];

                    final posterPathVal = item['posterPath'] ?? item['poster_path'] ?? '';
                    final voteAvgVal = (item['voteAverage'] ?? item['vote_average'] ?? 0.0).toDouble();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            posterPathVal.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w400$posterPathVal',
                                      width: 90,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const SizedBox(width: 90, height: 130, child: Icon(Icons.movie, size: 50)),
                                    ),
                                  )
                                : const SizedBox(width: 90, height: 130, child: Icon(Icons.movie, size: 50)),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '⭐ $voteAvgVal',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                              onPressed: () async {
                                await DatabaseHelper.instance.removeMovieFromList(item['id'], widget.listType);
                                _loadMovies();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}