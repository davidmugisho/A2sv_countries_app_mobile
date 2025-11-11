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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<CountriesCubit, CountriesState>(
          builder: (context, state) {
            final textColor = theme.textTheme.titleLarge?.color ?? Colors.white;
            if (state is CountryDetailLoaded) {
              return Text(
                state.country.name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            return Text(
              'Country Details',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          if (state is CountriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CountryDetailLoaded) {
            final country = state.country;

            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Hero(
                  tag: country.code,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    height: 220,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        country.flagUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.flag, size: 64, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Statistics',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatCard(
                        context,
                        'Area',
                        '${_formatNumber(country.area)} sq.km',
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        context,
                        'Population',
                        _formatNumber(country.population),
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(context, 'Region', country.region),
                      const SizedBox(height: 12),
                      _buildStatCard(context, 'Sub Region', country.subregion),
                      const SizedBox(height: 24),
                      Text(
                        'Timezone(s)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: country.timezones.map((tz) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tz,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CountriesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context
                          .read<CountriesCubit>()
                          .getCountryDetails(widget.countryCode),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(dynamic number) {
    if (number == null) return 'N/A';
    int num;
    if (number is String) {
      num = int.tryParse(number) ?? 0;
    } else if (number is int) {
      num = number;
    } else if (number is double) {
      num = number.toInt();
    } else {
      return number.toString();
    }

    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(2)} million';
    } else if (num >= 1000) {
      return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return num.toString();
  }
}
