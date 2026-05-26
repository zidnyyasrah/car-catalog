import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/car_generation.dart';
import '../../models/car_model.dart';
import '../../providers/car_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/image_picker_tile.dart';

class GenerationFormScreen extends StatefulWidget {
  final CarModel model;
  final CarGeneration? existing;
  const GenerationFormScreen({
    super.key,
    required this.model,
    this.existing,
  });

  @override
  State<GenerationFormScreen> createState() => _GenerationFormScreenState();
}

class _GenerationFormScreenState extends State<GenerationFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _chassis;
  late final TextEditingController _yearStart;
  late final TextEditingController _yearEnd;
  late final TextEditingController _description;
  File? _localImage;
  bool _busy = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    final g = widget.existing;
    _name = TextEditingController(text: g?.name ?? '');
    _chassis = TextEditingController(text: g?.chassisCode ?? '');
    _yearStart =
        TextEditingController(text: g == null ? '' : g.yearStart.toString());
    _yearEnd =
        TextEditingController(text: g?.yearEnd?.toString() ?? '');
    _description = TextEditingController(text: g?.description ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _chassis.dispose();
    _yearStart.dispose();
    _yearEnd.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ys = int.tryParse(_yearStart.text.trim());
    final ye = _yearEnd.text.trim().isEmpty
        ? null
        : int.tryParse(_yearEnd.text.trim());
    if (_name.text.trim().isEmpty || ys == null) {
      setState(() => _err = 'Nama generasi dan tahun mulai wajib diisi.');
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
        heroUrl =
            await provider.uploadImage(_localImage!, folder: 'generations');
      }
      await provider.saveGeneration(
        id: widget.existing?.id,
        modelId: widget.model.id,
        name: _name.text.trim(),
        chassisCode:
            _chassis.text.trim().isEmpty ? null : _chassis.text.trim(),
        yearStart: ys,
        yearEnd: ye,
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
      eyebrow:
          '${widget.model.brand} ${widget.model.name}  ·  ${isEdit ? 'EDIT GEN' : 'GEN BARU'}',
      title: isEdit ? widget.existing!.name : 'Tambah generasi',
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
                controller: _name,
                label: 'Nama generasi',
                hint: 'cth. Gen 3 Facelift'),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
                controller: _chassis,
                label: 'Kode sasis (opsional)',
                hint: 'cth. AN160'),
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
                    hint: 'kosong = sekarang',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
              controller: _description,
              label: 'Deskripsi',
              hint: 'Perubahan utama di generasi ini…',
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
              label: isEdit ? 'Simpan perubahan' : 'Tambah generasi',
              busy: _busy,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
