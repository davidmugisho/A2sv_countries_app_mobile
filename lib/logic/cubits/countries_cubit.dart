import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/country_models.dart';
import '../../data/repositories/countries_repository.dart';

part 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepository repository;
  final List<CountryDetails> _favorites = [];

  CountriesCubit({required this.repository}) : super(CountriesInitial());

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
}
