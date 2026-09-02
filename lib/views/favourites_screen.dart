import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouritesProvider>(context, listen: false).loadFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites Movies'),
        backgroundColor: const Color(0xFF020617),
      ),
      body: Consumer<FavouritesProvider>(
        builder: (context, favProvider, child) {
          if (favProvider.favourites.isEmpty) {
            return const Center(
              child: Text(
                'No favourites yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: favProvider.favourites.length,
            itemBuilder: (context, index) {
              final item = favProvider.favourites[index];

              final posterPathVal = item['posterPath'] ?? '';
              final voteAvgVal = (item['voteAverage'] ?? 0.0).toDouble();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0), 
                  child: Row(
                    children: [
                      posterPathVal.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w400$posterPathVal',
                                width: 90,
                                height: 126,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(width: 95, height: 135, child: Icon(Icons.movie, size: 45)),
                              ),
                            )
                          : const SizedBox(width: 95, height: 135, child: Icon(Icons.movie, size: 45)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 15,
                                color: Colors.amber,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                        onPressed: () {
                          Provider.of<FavouritesProvider>(context, listen: false)
                              .removeFavourite(item['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}