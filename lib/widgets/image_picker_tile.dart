import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

/// Tap-to-pick image tile used in all editor forms.
///
/// Shows a local preview after the user picks; the form is responsible for
/// taking [localFile] and calling `provider.uploadImage(...)` on submit.
class ImagePickerTile extends StatefulWidget {
  final String? initialUrl;
  final ValueChanged<File?> onChanged;
  final double aspectRatio;
  final String emptyLabel;

  const ImagePickerTile({
    super.key,
    required this.onChanged,
    this.initialUrl,
    this.aspectRatio = 16 / 10,
    this.emptyLabel = 'TAP UNTUK PILIH GAMBAR',
  });

  @override
  State<ImagePickerTile> createState() => _ImagePickerTileState();
}

class _ImagePickerTileState extends State<ImagePickerTile> {
  File? _local;
  final _picker = ImagePicker();

  Future<void> _pick() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 2000,
    );
    if (picked == null) return;
    setState(() => _local = File(picked.path));
    widget.onChanged(_local);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          onTap: _pick,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(color: AppTheme.hairline),
            ),
            clipBehavior: Clip.hardEdge,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_local != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_local!, fit: BoxFit.cover),
          const _OverlayLabel(text: 'GANTI'),
        ],
      );
    }
    final url = widget.initialUrl;
    if (url != null && url.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: AppTheme.surfaceElevated),
            errorWidget: (_, __, ___) => Container(
              color: AppTheme.surfaceElevated,
              child: const Icon(Icons.image_outlined,
                  color: AppTheme.textMuted, size: 36),
            ),
          ),
          const _OverlayLabel(text: 'GANTI'),
        ],
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_photo_alternate_outlined,
              color: AppTheme.textMuted, size: 36),
          const SizedBox(height: AppTheme.sm),
          Text(widget.emptyLabel,
              style: AppTheme.eyebrow(color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

class _OverlayLabel extends StatelessWidget {
  final String text;
  const _OverlayLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppTheme.md,
      bottom: AppTheme.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Text(text, style: AppTheme.eyebrow(color: AppTheme.onAccent)),
      ),
    );
  }
}
