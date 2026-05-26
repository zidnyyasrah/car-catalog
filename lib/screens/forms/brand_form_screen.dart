import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/car_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/form_fields.dart';

/// Create or edit a brand. `existingName` is null for create.
class BrandFormScreen extends StatefulWidget {
  final String? existingName;
  final String? existingCountry;
  const BrandFormScreen({
    super.key,
    this.existingName,
    this.existingCountry,
  });

  @override
  State<BrandFormScreen> createState() => _BrandFormScreenState();
}

class _BrandFormScreenState extends State<BrandFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _country;
  bool _busy = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existingName ?? '');
    _country = TextEditingController(text: widget.existingCountry ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _country.text.trim().isEmpty) {
      setState(() => _err = 'Nama dan negara wajib diisi.');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final provider = context.read<CarProvider>();
      String? id;
      if (widget.existingName != null) {
        // Edit path: look up id via repo so we keep the same row.
        id = await provider.brandIdByName(widget.existingName!);
      }
      await provider.saveBrand(
        id: id,
        name: _name.text.trim(),
        country: _country.text.trim(),
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
    final isEdit = widget.existingName != null;
    return FormScaffold(
      eyebrow: isEdit ? 'EDIT BRAND' : 'BRAND BARU',
      title: isEdit ? widget.existingName! : 'Tambah brand',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppTheme.xl, 0, AppTheme.xl, AppTheme.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
                controller: _name, label: 'Nama brand', hint: 'cth. Mazda'),
            const SizedBox(height: AppTheme.lg),
            AppTextField(
                controller: _country,
                label: 'Negara asal',
                hint: 'cth. Jepang'),
            const SizedBox(height: AppTheme.xl),
            if (_err != null) ...[
              Text(_err!,
                  style: const TextStyle(
                      color: Color(0xFFFF8585), fontSize: 12)),
              const SizedBox(height: AppTheme.md),
            ],
            SubmitBar(
              label: isEdit ? 'Simpan perubahan' : 'Tambah brand',
              busy: _busy,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
