part of 'countries_cubit.dart';

abstract class CountriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<CountryDetails> countries;
  CountriesLoaded(this.countries);

  @override
  List<Object?> get props => [countries];
}

class CountriesError extends CountriesState {
  final String message;
  CountriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CountryDetailLoaded extends CountriesState {
  final CountryDetails country;
  CountryDetailLoaded(this.country);

  @override
  List<Object?> get props => [country];
}

class FavoritesUpdated extends CountriesState {
  final List<CountryDetails> favorites;
  FavoritesUpdated(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
