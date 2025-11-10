import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/countries_cubit.dart';
import '../detail/detail_screen.dart';
import '../favorites/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CountriesCubit>().loadAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

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
      appBar: AppBar(title: const Text('Countries')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a country',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<CountriesCubit>().loadAll();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<CountriesCubit>().search(query);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CountriesCubit, CountriesState>(
              builder: (context, state) {
                if (state is CountriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CountriesLoaded) {
                  final countries = state.countries;
                  if (countries.isEmpty) {
                    return const Center(child: Text('No countries found.'));
                  }
                  return ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
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
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () async {
                            final details = await context
                                .read<CountriesCubit>()
                                .repository
                                .getCountryDetails(country.code);
                            context.read<CountriesCubit>().toggleFavorite(
                              details,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${details.name} added to favorites',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
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
                } else if (state is CountriesError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
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
