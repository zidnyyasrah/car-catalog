import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../theme/app_theme.dart';
import 'car_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            _SearchBar(),
            _ActiveFiltersRow(),
            Expanded(child: _CarGrid()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CarCat',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Katalog Mobil Indonesia',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer<CarProvider>(
            builder: (_, provider, __) {
              final count = provider.filteredCars.length;
              return Text(
                '$count mobil',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: context.read<CarProvider>().updateSearch,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari brand, model, varian...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                suffixIcon: Consumer<CarProvider>(
                  builder: (_, provider, __) {
                    if (provider.filter.searchQuery.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary, size: 18),
                      onPressed: () => provider.updateSearch(''),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Consumer<CarProvider>(
            builder: (_, provider, __) {
              final hasFilters = provider.filter.hasActiveFilters;
              return GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const FilterBottomSheet(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasFilters
                        ? AppTheme.accent.withOpacity(0.15)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasFilters ? AppTheme.accent : const Color(0xFF2A2A4E),
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: hasFilters ? AppTheme.accent : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow();

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (_, provider, __) {
        final filter = provider.filter;
        final chips = <_FilterChipData>[];

        if (filter.brand != null) {
          chips.add(_FilterChipData(label: filter.brand!, onRemove: () {
            provider.updateFilter(filter.copyWith(clearBrand: true));
          }));
        }
        if (filter.bodyType != null) {
          chips.add(_FilterChipData(label: filter.bodyType!, onRemove: () {
            provider.updateFilter(filter.copyWith(clearBodyType: true));
          }));
        }
        if (filter.transmission != null) {
          chips.add(_FilterChipData(label: filter.transmission!, onRemove: () {
            provider.updateFilter(filter.copyWith(clearTransmission: true));
          }));
        }
        if (filter.driveSystem != null) {
          chips.add(_FilterChipData(label: filter.driveSystem!, onRemove: () {
            provider.updateFilter(filter.copyWith(clearDriveSystem: true));
          }));
        }

        if (chips.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 36,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              ...chips.map((chip) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ActiveChip(data: chip),
                  )),
              GestureDetector(
                onTap: provider.clearFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2A2A4E)),
                  ),
                  child: const Center(
                    child: Text(
                      'Hapus semua',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChipData {
  final String label;
  final VoidCallback onRemove;
  const _FilterChipData({required this.label, required this.onRemove});
}

class _ActiveChip extends StatelessWidget {
  final _FilterChipData data;
  const _ActiveChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.label,
            style: const TextStyle(color: AppTheme.accent, fontSize: 12),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: data.onRemove,
            child: const Icon(Icons.close, size: 14, color: AppTheme.accent),
          ),
        ],
      ),
    );
  }
}

class _CarGrid extends StatelessWidget {
  const _CarGrid();

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (_, provider, __) {
        final cars = provider.filteredCars;

        if (cars.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car_outlined, size: 64, color: AppTheme.textSecondary),
                SizedBox(height: 12),
                Text(
                  'Tidak ada mobil ditemukan',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Coba ubah filter pencarian',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return CarCard(
              car: car,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
              ),
            );
          },
        );
      },
    );
  }
}
