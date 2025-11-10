class ApiEndpoints {
  static const String base = 'https://restcountries.com/v3.1';
  static const String allSummaries =
      '$base/all?fields=name,flags,population,cca2';
  static const String searchByName = '$base/name'; // append /{name}?fields=...
  static const String detailsByCode =
      '$base/alpha'; // append /{code}?fields=...
}
