import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/brand_info.dart';

class BrandLogo extends StatelessWidget {
  final BrandInfo info;
  final double fallbackFontSize;
  final Color? tint;

  const BrandLogo({
    super.key,
    required this.info,
    this.fallbackFontSize = 28,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final asset = info.logoAsset;
    final Widget logo = asset != null
        ? SvgPicture.asset(
            asset,
            fit: BoxFit.contain,
            colorFilter: tint == null
                ? null
                : ColorFilter.mode(tint!, BlendMode.srcIn),
            placeholderBuilder: (_) => _fallback(),
          )
        : _fallback();

    if (info.logoScale == 1.0) return logo;
    return ClipRect(
      child: Transform.scale(scale: info.logoScale, child: logo),
    );
  }

  Widget _fallback() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          info.name.toUpperCase(),
          style: TextStyle(
            color: tint ?? info.primary,
            fontSize: fallbackFontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
