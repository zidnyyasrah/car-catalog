import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FormSection extends StatelessWidget {
  final String label;
  final Widget child;
  const FormSection({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTheme.eyebrow(color: AppTheme.textPrimary)),
            const SizedBox(width: AppTheme.md),
            Expanded(child: Container(height: 1, color: AppTheme.hairline)),
          ],
        ),
        const SizedBox(height: AppTheme.lg),
        child,
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTheme.eyebrow()),
        const SizedBox(height: AppTheme.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(hintText: hint),
          validator: validator,
        ),
      ],
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTheme.eyebrow()),
        const SizedBox(height: AppTheme.sm),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.surfaceElevated,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(itemLabel(e))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class AppSwitchTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitchTile({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.hairline),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.lg, vertical: AppTheme.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: AppTheme.eyebrow()),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12)),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accent,
          ),
        ],
      ),
    );
  }
}

/// Submit button styled as the lime pill from the reference.
class SubmitBar extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onTap;

  const SubmitBar({
    super.key,
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.accent,
      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        onTap: busy ? null : onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.onAccent,
                  ),
                )
              : Text(label.toUpperCase(),
                  style: AppTheme.eyebrow(color: AppTheme.onAccent)
                      .copyWith(fontSize: 13)),
        ),
      ),
    );
  }
}

/// Chip-style editor for free-form list values (colors, features).
class ListChipsEditor extends StatefulWidget {
  final String label;
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;
  final String addHint;

  const ListChipsEditor({
    super.key,
    required this.label,
    required this.initial,
    required this.onChanged,
    this.addHint = 'Tambah…',
  });

  @override
  State<ListChipsEditor> createState() => _ListChipsEditorState();
}

class _ListChipsEditorState extends State<ListChipsEditor> {
  late List<String> _items;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = [...widget.initial];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final v = _controller.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _items.add(v);
      _controller.clear();
    });
    widget.onChanged(_items);
  }

  void _remove(int i) {
    setState(() => _items.removeAt(i));
    widget.onChanged(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AppTheme.eyebrow()),
        const SizedBox(height: AppTheme.sm),
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.sm),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (int i = 0; i < _items.length; i++)
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.hairline),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_items[i],
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _remove(i),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close_rounded,
                                size: 14, color: AppTheme.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(hintText: widget.addHint),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: AppTheme.sm),
            Material(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                onTap: _add,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.add_rounded,
                      color: AppTheme.onAccent, size: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bare scaffold shared by all form screens.
class FormScaffold extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget child;

  const FormScaffold({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.lg, AppTheme.md, AppTheme.lg, 0),
              child: Row(
                children: [
                  Material(
                    color: AppTheme.surface,
                    shape: const CircleBorder(
                      side: BorderSide(color: AppTheme.hairline),
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close_rounded,
                            size: 18, color: AppTheme.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTheme.xl, AppTheme.lg, AppTheme.xl, AppTheme.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eyebrow.toUpperCase(),
                      style: AppTheme.eyebrow(color: AppTheme.accent)),
                  const SizedBox(height: AppTheme.sm),
                  Text(title, style: AppTheme.display(size: 32)),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
