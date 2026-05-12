import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car_filter.dart';
import '../providers/car_provider.dart';
import '../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late CarFilter _localFilter;
  late CarProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CarProvider>();
    _localFilter = _provider.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _localFilter = const CarFilter()),
                child: const Text('Reset', style: TextStyle(color: AppTheme.accent)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterSection(
            title: 'Brand',
            items: _provider.brands,
            selected: _localFilter.brand,
            onSelect: (val) => setState(() =>
                _localFilter = _localFilter.copyWith(
                  brand: val,
                  clearBrand: val == null,
                )),
          ),
          const SizedBox(height: 16),
          _FilterSection(
            title: 'Tipe Kendaraan',
            items: _provider.bodyTypes,
            selected: _localFilter.bodyType,
            onSelect: (val) => setState(() =>
                _localFilter = _localFilter.copyWith(
                  bodyType: val,
                  clearBodyType: val == null,
                )),
          ),
          const SizedBox(height: 16),
          _FilterSection(
            title: 'Transmisi',
            items: CarProvider.transmissions,
            selected: _localFilter.transmission,
            onSelect: (val) => setState(() =>
                _localFilter = _localFilter.copyWith(
                  transmission: val,
                  clearTransmission: val == null,
                )),
          ),
          const SizedBox(height: 16),
          _FilterSection(
            title: 'Sistem Penggerak',
            items: _provider.driveSystems,
            selected: _localFilter.driveSystem,
            onSelect: (val) => setState(() =>
                _localFilter = _localFilter.copyWith(
                  driveSystem: val,
                  clearDriveSystem: val == null,
                )),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<CarProvider>().updateFilter(_localFilter);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Terapkan Filter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _FilterSection({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selected == item;
            return GestureDetector(
              onTap: () => onSelect(isSelected ? null : item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accent.withOpacity(0.15)
                      : AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : const Color(0xFF2A2A4E),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
