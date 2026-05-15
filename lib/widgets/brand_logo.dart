import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/brand_info.dart';

class BrandLogo extends StatelessWidget {
  final BrandInfo info;
  final double fallbackFontSize;

  const BrandLogo({
    super.key,
    required this.info,
    this.fallbackFontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final asset = info.logoAsset;
    if (asset != null) {
      return SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          info.name.toUpperCase(),
          style: TextStyle(
            color: info.primary,
            fontSize: fallbackFontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
