import 'package:dio/dio.dart';
import '../models/country_models.dart';

class CountriesApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://restcountries.com/v3.1/'));

  Future<List<CountryDetails>> fetchAllSummaries() async {
    try {
      final response = await _dio.get(
        'all',
        queryParameters: {
          'fields':
              'name,flags,population,capital,region,subregion,area,timezones,cca2',
        },
      );
      final data = response.data as List<dynamic>;
      return data.map((json) => CountryDetails.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch countries: $e');
    }
  }

  Future<List<CountryDetails>> searchByName(String query) async {
    try {
      final response = await _dio.get(
        'name/$query',
        queryParameters: {
          'fields':
              'name,flags,population,capital,region,subregion,area,timezones,cca2',
        },
      );
      final data = response.data as List<dynamic>;
      return data.map((json) => CountryDetails.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<CountryDetails> fetchDetailsByCode(String cca2) async {
    try {
      final response = await _dio.get(
        'alpha/$cca2',
        queryParameters: {
          'fields':
              'name,flags,population,capital,region,subregion,area,timezones,cca2',
        },
      );
      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        throw Exception('Country not found');
      }
      final jsonData = response.data is List ? response.data[0] : response.data;
      return CountryDetails.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to fetch country details: $e');
    }
  }
}
