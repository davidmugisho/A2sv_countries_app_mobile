import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/countries_repository.dart';
import 'data/services/countries_api_service.dart';
import 'logic/cubits/countries_cubit.dart';
import 'presentation/screens/home/home_screen.dart';

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
        title: 'Countries App',
        debugShowCheckedModeBanner: false,

        //this use DARK MODE SUPPORT
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
