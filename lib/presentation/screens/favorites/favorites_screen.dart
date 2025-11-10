import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/countries_cubit.dart';
import '../detail/detail_screen.dart';
import '../home/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    final target = index == 0 ? const HomeScreen() : const FavoritesScreen();
    Navigator.of(context).pushReplacement(_createFadeRoute(target));
  }

  Route _createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          final favorites = context.read<CountriesCubit>().favorites;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final country = favorites[index];
              return ListTile(
                leading: Image.network(
                  country.flagUrl,
                  width: 50,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                title: Text(country.name),
                subtitle: Text('Population: ${country.population}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    context.read<CountriesCubit>().toggleFavorite(country);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${country.name} removed from favorites'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    setState(() {});
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CountriesCubit>(),
                        child: DetailScreen(countryCode: country.code),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
