import '../services/countries_api_service.dart';
import '../models/country_models.dart';

class CountriesRepository {
  final CountriesApiService apiService;

  CountriesRepository({required this.apiService});

  Future<List<CountryDetails>> getAllCountries() async {
    return apiService.fetchAllSummaries();
  }

  Future<List<CountryDetails>> searchCountries(String query) async {
    if (query.trim().isEmpty) return [];
    return apiService.searchByName(query);
  }

  Future<CountryDetails> getCountryDetails(String cca2) async {
    return apiService.fetchDetailsByCode(cca2);
  }
}
