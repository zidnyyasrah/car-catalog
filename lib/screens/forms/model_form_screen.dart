import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/car_model.dart';
import '../../providers/car_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/image_picker_tile.dart';

class ModelFormScreen extends StatefulWidget {
  /// Either editing an existing model, or creating one for [brand].
  final String brand;
  final CarModel? existing;
  const ModelFormScreen({super.key, required this.brand, this.existing});

  @override
  State<ModelFormScreen> createState() => _ModelFormScreenState();
}

class _ModelFormScreenState extends State<ModelFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _bodyType;
  late final TextEditingController _description;
  File? _localImage;
  bool _busy = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _name = TextEditingController(text: m?.name ?? '');
    _bodyType = TextEditingController(text: m?.bodyType ?? '');
    _description = TextEditingController(text: m?.description ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _bodyType.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _bodyType.text.trim().isEmpty) {
      setState(() => _err = 'Nama model dan tipe bodi wajib diisi.');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final provider = context.read<CarProvider>();
      String? heroUrl = widget.existing?.heroImageUrl;
      if (_localImage != null) {
        heroUrl = await provider.uploadImage(_localImage!, folder: 'models');
      }
      await provider.saveModel(
        id: widget.existing?.id,
        brandName: widget.brand,
        name: _name.text.trim(),
        bodyType: _bodyType.text.trim(),
        description: _description.text.trim(),
        heroImageUrl: heroUrl,
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
      eyebrow: '${widget.brand}  ·  ${isEdit ? 'EDIT MODEL' : 'MODEL BARU'}',
      title: isEdit ? widget.existing!.name : 'Tambah model',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppTheme.xl, 0, AppTheme.xl, AppTheme.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagePickerTile(
              initialUrl: widget.existing?.heroImageUrl,
              onChanged: (f) => setState(() => _localImage = f),
            ),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
                controller: _name, label: 'Nama model', hint: 'cth. CX-5'),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
                controller: _bodyType,
                label: 'Tipe bodi',
                hint: 'SUV / Sedan / MPV / Hatchback'),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
              controller: _description,
              label: 'Deskripsi',
              hint: 'Ringkasan singkat model ini…',
              maxLines: 4,
            ),
            const SizedBox(height: AppTheme.xl),
            if (_err != null) ...[
              Text(_err!,
                  style: const TextStyle(
                      color: Color(0xFFFF8585), fontSize: 12)),
              const SizedBox(height: AppTheme.md),
            ],
            SubmitBar(
              label: isEdit ? 'Simpan perubahan' : 'Tambah model',
              busy: _busy,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
