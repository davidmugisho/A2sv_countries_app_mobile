import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/cubits/countries_cubit.dart';
import 'data/repositories/countries_repository.dart';
import 'data/services/countries_api_service.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/favorites/favorites_screen.dart';

void main() {
  final apiService = CountriesApiService();
  final repository = CountriesRepository(apiService: apiService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final CountriesRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountriesCubit(repository: repository)..loadAll(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countries App',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
