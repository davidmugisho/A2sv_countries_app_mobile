import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/country_models.dart';
import '../../data/repositories/countries_repository.dart';

part 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepository repository;
  final List<CountryDetails> _favorites = [];

  CountriesCubit({required this.repository}) : super(CountriesInitial()) {
    _loadFavorites();
  }

  List<CountryDetails> get favorites => List.unmodifiable(_favorites);

  Future<void> loadAll() async {
    emit(CountriesLoading());
    try {
      final list = await repository.getAllCountries();
      emit(CountriesLoaded(list));
    } catch (e) {
      emit(CountriesError('Failed to load countries'));
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      loadAll();
      return;
    }
    emit(CountriesLoading());
    try {
      final results = await repository.searchCountries(query);
      emit(CountriesLoaded(results));
    } catch (e) {
      emit(CountriesError('Search failed'));
    }
  }

  Future<void> getCountryDetails(String code) async {
    emit(CountriesLoading());
    try {
      final country = await repository.getCountryDetails(code);
      emit(CountryDetailLoaded(country));
    } catch (e) {
      emit(CountriesError('Failed to load country details'));
    }
  }

  void toggleFavorite(CountryDetails country) {
    if (_favorites.any((c) => c.code == country.code)) {
      _favorites.removeWhere((c) => c.code == country.code);
    } else {
      _favorites.add(country);
    }
    _saveFavorites();
    emit(FavoritesUpdated(List.from(_favorites)));
  }

  Future<void> toggleFavoriteByCode(String code) async {
    try {
      final country = await repository.getCountryDetails(code);
      toggleFavorite(country);
    } catch (e) {
      emit(CountriesError('Failed to add favorite'));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _favorites
        .map(
          (c) => jsonEncode({
            'name': c.name,
            'flagUrl': c.flagUrl,
            'population': c.population,
            'code': c.code,
            'capital': c.capital,
          }),
        )
        .toList();
    await prefs.setStringList('favorites', data);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorites') ?? [];
    _favorites.clear();
    _favorites.addAll(
      data.map((str) {
        final json = jsonDecode(str);
        return CountryDetails(
          name: json['name'],
          flagUrl: json['flagUrl'],
          population: json['population'],
          code: json['code'],
          capital: json['capital'],
          region: '',
          subregion: '',
          area: 0,
          timezones: const [],
        );
      }),
    );
    emit(FavoritesUpdated(List.from(_favorites)));
  }
}
