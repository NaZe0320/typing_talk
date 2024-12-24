import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const IconWidget({
    super.key,
    required this.assetName,
    this.size = 24,
    this.color,
    this.onTap,
  }) : assert(size == 16 || size == 24, 'Size must be either 16 or 24');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        "assets/icons/${assetName}_${size.toInt()}.svg",
        width: size,
        height: size,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
