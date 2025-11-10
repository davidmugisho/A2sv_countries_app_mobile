import 'package:equatable/equatable.dart';

class CountrySummary extends Equatable {
  final String name;
  final String flagUrl;
  final int population;
  final String code;

  const CountrySummary({
    required this.name,
    required this.flagUrl,
    required this.population,
    required this.code,
  });

  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    return CountrySummary(
      name: (json['name']?['common'] as String?) ?? 'Unknown',
      flagUrl: (json['flags']?['png'] as String?) ?? '',
      population: (json['population'] as int?) ?? 0,
      code: (json['cca2'] as String?) ?? '',
    );
  }

  @override
  List<Object?> get props => [name, flagUrl, population, code];
}

class CountryDetails extends Equatable {
  final String name;
  final String flagUrl;
  final int population;
  final String capital;
  final String region;
  final String subregion;
  final double area;
  final List<String> timezones;
  final String code;

  const CountryDetails({
    required this.name,
    required this.flagUrl,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
    required this.code,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) {
    final capitalList =
        (json['capital'] as List<dynamic>?)?.cast<String>() ?? [];
    return CountryDetails(
      name: (json['name']?['common'] as String?) ?? 'Unknown',
      flagUrl: (json['flags']?['png'] as String?) ?? '',
      population: (json['population'] as int?) ?? 0,
      capital: capitalList.isNotEmpty ? capitalList[0] : 'N/A',
      region: (json['region'] as String?) ?? 'N/A',
      subregion: (json['subregion'] as String?) ?? 'N/A',
      area: ((json['area'] ?? 0) as num).toDouble(),
      timezones: (json['timezones'] as List<dynamic>?)?.cast<String>() ?? [],
      code: (json['cca2'] as String?) ?? '',
    );
  }

  @override
  List<Object?> get props => [
    name,
    flagUrl,
    population,
    capital,
    region,
    subregion,
    area,
    timezones,
    code,
  ];
}
