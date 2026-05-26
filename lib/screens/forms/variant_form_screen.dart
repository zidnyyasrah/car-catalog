import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/car.dart';
import '../../models/car_generation.dart';
import '../../providers/car_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/image_picker_tile.dart';

class VariantFormScreen extends StatefulWidget {
  final CarGeneration generation;
  final Car? existing;
  const VariantFormScreen({
    super.key,
    required this.generation,
    this.existing,
  });

  @override
  State<VariantFormScreen> createState() => _VariantFormScreenState();
}

class _VariantFormScreenState extends State<VariantFormScreen> {
  late final TextEditingController _trim;
  late final TextEditingController _yearStart;
  late final TextEditingController _yearEnd;
  late final TextEditingController _engineType;
  late final TextEditingController _engineCc;
  late final TextEditingController _powerHp;
  late final TextEditingController _torqueNm;
  late final TextEditingController _transmission;
  late final TextEditingController _drive;
  late final TextEditingController _fuel;
  late final TextEditingController _seats;
  late final TextEditingController _clearance;
  late final TextEditingController _dimensions;
  late final TextEditingController _priceMin;
  late final TextEditingController _priceMax;
  late final TextEditingController _description;

  bool _isElectric = false;
  int _safetyRating = 0;
  List<String> _colors = [];
  List<String> _features = [];
  File? _localImage;
  bool _busy = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    final v = widget.existing;
    _trim = TextEditingController(text: v?.variant ?? '');
    _yearStart = TextEditingController(
        text: v?.yearStart.toString() ?? widget.generation.yearStart.toString());
    _yearEnd = TextEditingController(text: v?.yearEnd?.toString() ?? '');
    _engineType = TextEditingController(text: v?.engineType ?? '');
    _engineCc =
        TextEditingController(text: v?.engineDisplacementCc.toString() ?? '0');
    _powerHp = TextEditingController(text: v?.powerHp.toString() ?? '0');
    _torqueNm = TextEditingController(text: v?.torqueNm.toString() ?? '0');
    _transmission = TextEditingController(text: v?.transmission ?? '');
    _drive = TextEditingController(text: v?.driveSystem ?? '');
    _fuel = TextEditingController(
        text: v?.fuelConsumptionKmPerL.toString() ?? '0');
    _seats =
        TextEditingController(text: v?.seatingCapacity.toString() ?? '5');
    _clearance =
        TextEditingController(text: v?.groundClearanceMm.toString() ?? '0');
    _dimensions = TextEditingController(text: v?.lengthWidthHeightMm ?? '');
    _priceMin =
        TextEditingController(text: v?.priceMinMillionIdr.toString() ?? '0');
    _priceMax =
        TextEditingController(text: v?.priceMaxMillionIdr.toString() ?? '0');
    _description = TextEditingController(text: v?.description ?? '');
    _isElectric = v?.isElectric ?? false;
    _safetyRating = v?.safetyRatingStars ?? 0;
    _colors = [...(v?.colors ?? const [])];
    _features = [...(v?.features ?? const [])];
  }

  @override
  void dispose() {
    for (final c in [
      _trim,
      _yearStart,
      _yearEnd,
      _engineType,
      _engineCc,
      _powerHp,
      _torqueNm,
      _transmission,
      _drive,
      _fuel,
      _seats,
      _clearance,
      _dimensions,
      _priceMin,
      _priceMax,
      _description,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final ys = int.tryParse(_yearStart.text.trim());
    if (_trim.text.trim().isEmpty || ys == null) {
      setState(() => _err = 'Nama varian dan tahun mulai wajib diisi.');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final provider = context.read<CarProvider>();
      String? imageUrl = widget.existing?.imageUrl;
      if (_localImage != null) {
        imageUrl =
            await provider.uploadImage(_localImage!, folder: 'variants');
      }
      await provider.saveVariant(
        id: widget.existing?.id,
        generationId: widget.generation.id,
        trimName: _trim.text.trim(),
        yearStart: ys,
        yearEnd: _yearEnd.text.trim().isEmpty
            ? null
            : int.tryParse(_yearEnd.text.trim()),
        engineType: _engineType.text.trim(),
        engineDisplacementCc: int.tryParse(_engineCc.text.trim()) ?? 0,
        powerHp: int.tryParse(_powerHp.text.trim()) ?? 0,
        torqueNm: int.tryParse(_torqueNm.text.trim()) ?? 0,
        transmission: _transmission.text.trim(),
        driveSystem: _drive.text.trim(),
        isElectric: _isElectric,
        fuelConsumptionKmPerL: double.tryParse(_fuel.text.trim()) ?? 0,
        seatingCapacity: int.tryParse(_seats.text.trim()) ?? 5,
        groundClearanceMm: int.tryParse(_clearance.text.trim()) ?? 0,
        dimensions:
            _dimensions.text.trim().isEmpty ? null : _dimensions.text.trim(),
        safetyRating: _safetyRating,
        priceMinMillionIdr: double.tryParse(_priceMin.text.trim()) ?? 0,
        priceMaxMillionIdr: double.tryParse(_priceMax.text.trim()) ?? 0,
        imageUrl: imageUrl,
        description: _description.text.trim(),
        colors: _colors,
        features: _features,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _err = e.toString();
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return FormScaffold(
      eyebrow:
          '${widget.generation.name}  ·  ${isEdit ? 'EDIT VARIAN' : 'VARIAN BARU'}',
      title: isEdit ? widget.existing!.variant : 'Tambah varian',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppTheme.xl, 0, AppTheme.xl, AppTheme.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagePickerTile(
              initialUrl: widget.existing?.imageUrl,
              onChanged: (f) => setState(() => _localImage = f),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'IDENTITAS',
              child: Column(
                children: [
                  AppTextField(
                      controller: _trim,
                      label: 'Nama varian',
                      hint: 'cth. 2.8 VRZ A/T'),
                  const SizedBox(height: AppTheme.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _yearStart,
                          label: 'Tahun mulai',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                          controller: _yearEnd,
                          label: 'Tahun selesai',
                          hint: 'opsional',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'MESIN',
              child: Column(
                children: [
                  AppSwitchTile(
                    label: 'Electric',
                    subtitle: 'Tandai jika varian ini full EV',
                    value: _isElectric,
                    onChanged: (v) => setState(() => _isElectric = v),
                  ),
                  const SizedBox(height: AppTheme.lg),
                  AppTextField(
                      controller: _engineType,
                      label: 'Tipe mesin',
                      hint: 'cth. 2GD-FTV Diesel / Permanent Magnet AC'),
                  const SizedBox(height: AppTheme.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _engineCc,
                          label: 'Kapasitas (cc)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                          controller: _fuel,
                          label: 'BBM (km/L)',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _powerHp,
                          label: 'Tenaga (HP)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                          controller: _torqueNm,
                          label: 'Torsi (Nm)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                            controller: _transmission,
                            label: 'Transmisi',
                            hint: 'A/T 6-Speed'),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                            controller: _drive,
                            label: 'Penggerak',
                            hint: '4WD / FWD / RWD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'DIMENSI & UMUM',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _seats,
                          label: 'Kursi',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                          controller: _clearance,
                          label: 'Ground clearance (mm)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  AppTextField(
                      controller: _dimensions,
                      label: 'Dimensi P×L×T',
                      hint: '4795 × 1855 × 1835'),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'HARGA & RATING',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _priceMin,
                          label: 'Harga min (Jt IDR)',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: AppTextField(
                          controller: _priceMax,
                          label: 'Harga max (Jt IDR)',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.lg),
                  _SafetyStars(
                    value: _safetyRating,
                    onChanged: (v) => setState(() => _safetyRating = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'DESKRIPSI',
              child: AppTextField(
                controller: _description,
                label: 'Deskripsi varian',
                hint: 'Highlight & keunggulan…',
                maxLines: 5,
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'WARNA',
              child: ListChipsEditor(
                label: 'Daftar warna',
                initial: _colors,
                onChanged: (v) => _colors = v,
                addHint: 'cth. Putih Mutiara',
              ),
            ),
            const SizedBox(height: AppTheme.xl),
            FormSection(
              label: 'FITUR',
              child: ListChipsEditor(
                label: 'Daftar fitur',
                initial: _features,
                onChanged: (v) => _features = v,
                addHint: 'cth. Toyota Safety Sense',
              ),
            ),
            const SizedBox(height: AppTheme.xxl),
            if (_err != null) ...[
              Text(_err!,
                  style: const TextStyle(
                      color: Color(0xFFFF8585), fontSize: 12)),
              const SizedBox(height: AppTheme.md),
            ],
            SubmitBar(
              label: isEdit ? 'Simpan perubahan' : 'Tambah varian',
              busy: _busy,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyStars extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _SafetyStars({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RATING KESELAMATAN', style: AppTheme.eyebrow()),
        const SizedBox(height: AppTheme.sm),
        Row(
          children: List.generate(5, (i) {
            final filled = i < value;
            return InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onChanged(i + 1 == value ? 0 : i + 1),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 28,
                  color: filled ? AppTheme.accent : AppTheme.textMuted,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
