import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/countries_cubit.dart';

class DetailScreen extends StatefulWidget {
  final String countryCode;
  const DetailScreen({super.key, required this.countryCode});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CountriesCubit>().getCountryDetails(widget.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CountriesCubit, CountriesState>(
          builder: (context, state) {
            if (state is CountryDetailLoaded) {
              return Text(state.country.name);
            }
            return const Text('Country Details');
          },
        ),
      ),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          if (state is CountriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CountryDetailLoaded) {
            final country = state.country;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      country.flagUrl,
                      width: 200,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    country.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Capital: ${country.capital}'),
                  Text('Region: ${country.region}'),
                  Text('Subregion: ${country.subregion}'),
                  Text('Population: ${country.population}'),
                  Text('Area: ${country.area} km²'),
                  const SizedBox(height: 16),
                  const Text(
                    'Timezones',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...country.timezones.map((tz) => Text(tz)).toList(),
                ],
              ),
            );
          } else if (state is CountriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CountriesCubit>().getCountryDetails(
                        widget.countryCode,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
