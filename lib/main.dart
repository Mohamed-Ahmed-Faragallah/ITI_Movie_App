import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iti_movie_app/views/login_screen.dart';
import 'firebase_options.dart'; 
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'providers/movie_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favourites_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/app_theme.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        theme: AppTheme.darkTheme,
        home: const LoginScreen(), 
      ),
    );
  }
}