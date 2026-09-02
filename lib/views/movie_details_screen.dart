import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import '../database/database_helper.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Result movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();

  List<String> genres = [];
  bool isLoadingGenres = true;

  bool isWatched = false;
  bool isWatching = false;
  bool isWantToWatch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouritesProvider>(context, listen: false).loadFavourites();
    });
    _loadGenres();
    _checkUserLists();
  }

  Future<void> _checkUserLists() async {
    final watched = await DatabaseHelper.instance.isMovieInList(widget.movie.id, 'WATCHED');
    final watching = await DatabaseHelper.instance.isMovieInList(widget.movie.id, 'WATCHING');
    final wantToWatch = await DatabaseHelper.instance.isMovieInList(widget.movie.id, 'WANT_TO_WATCH');
    
    if (!mounted) return;
    setState(() {
      isWatched = watched;
      isWatching = watching;
      isWantToWatch = wantToWatch;
    });
  }

  Future<void> _loadGenres() async {
    try {
      final result = await _movieService.getMovieGenres(widget.movie.id);
      if (!mounted) return;
      setState(() {
        genres = result;
        isLoadingGenres = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingGenres = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title), backgroundColor: Colors.grey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${movie.voteAverage}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today, size: 18 ,  color: Colors.white),
                          const SizedBox(width: 4),
                        Text(
  movie.releaseDate != null
      ? '${movie.releaseDate!.year}-${movie.releaseDate!.month}-${movie.releaseDate!.day}'
      : 'N/A',
),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (isLoadingGenres)
                        const SizedBox(
                          height: 30,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (genres.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: genres.map((g) => Chip(label: Text(g))).toList(),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        'Overview',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview ?? 'No overview available.',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie, size: 80),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Consumer<FavouritesProvider>(
                            builder: (context, favProvider, child) {
                              final isFav = favProvider.isFavourite(movie.id);
                              return CircleAvatar(
                                backgroundColor: Colors.white70,
                                child: IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    if (isFav) {
                                      favProvider.removeFavourite(movie.id);
                                    } else {
                                      favProvider.addFavourite({
                                        'id': movie.id,
                                        'title': movie.title,
                                        'posterPath': movie.posterPath,
                                        'voteAverage': movie.voteAverage,
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'My Movie Lists',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWatched ? Colors.green : Colors.grey[200],
                    foregroundColor: isWatched ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    if (isWatched) {
                      await DatabaseHelper.instance.removeMovieFromList(movie.id, 'WATCHED');
                      setState(() => isWatched = false);
                    } else {
                      await DatabaseHelper.instance.addMovieToList(movie.toJson(), 'WATCHED');
                      setState(() => isWatched = true);
                    }
                  },
                  icon: Icon(isWatched ? Icons.check_circle : Icons.check),
                  label: const Text('Watched'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWatching ? Colors.orange : Colors.grey[200],
                    foregroundColor: isWatching ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    if (isWatching) {
                      await DatabaseHelper.instance.removeMovieFromList(movie.id, 'WATCHING');
                      setState(() => isWatching = false);
                    } else {
                      await DatabaseHelper.instance.addMovieToList(movie.toJson(), 'WATCHING');
                      setState(() => isWatching = true);
                    }
                  },
                  icon: Icon(isWatching ? Icons.hourglass_full : Icons.play_arrow),
                  label: const Text('Watching'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWantToWatch ? Colors.blue : Colors.grey[200],
                    foregroundColor: isWantToWatch ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    if (isWantToWatch) {
                      await DatabaseHelper.instance.removeMovieFromList(movie.id, 'WANT_TO_WATCH');
                      setState(() => isWantToWatch = false);
                    } else {
                      await DatabaseHelper.instance.addMovieToList(movie.toJson(), 'WANT_TO_WATCH');
                      setState(() => isWantToWatch = true);
                    }
                  },
                  icon: Icon(isWantToWatch ? Icons.bookmark : Icons.bookmark_border),
                  label: const Text('Want to Watch'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}