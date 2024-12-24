import 'package:flutter/material.dart';

class AppFonts {
  static const notoSansKr = 'NotoSansKR';
  static const inter = 'Inter';
  static const caveat = 'Caveat';
}

class AppTypography {
  // Font Features for all text styles
  static const List<FontFeature> _features = [FontFeature.tabularFigures()];

  // TextStyle Factory
  static TextStyle _createStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFeatures: _features,
      fontFamily: AppFonts.inter,
      fontFamilyFallback: [AppFonts.notoSansKr],
      height: 1.2,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  // Heading 1 (32px)
  static final h1_7 = _createStyle(fontSize: 32, fontWeight: FontWeight.w700);

  // Heading 2 (24px)
  static final h2_7 = _createStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static final h2_6 = _createStyle(fontSize: 24, fontWeight: FontWeight.w600);

  // Heading 3 (20px)
  static final h3_6 = _createStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static final h3_5 = _createStyle(fontSize: 20, fontWeight: FontWeight.w500);

  // Body Large (18px)
  static final b1_4 = _createStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static final b1_5 = _createStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static final b1_6 = _createStyle(fontSize: 18, fontWeight: FontWeight.w600);

  // Body Regular (16px)
  static final b2_4 = _createStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static final b2_5 = _createStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static final b2_6 = _createStyle(fontSize: 16, fontWeight: FontWeight.w600);

  // Body Small (14px)
  static final b3_4 = _createStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static final b3_5 = _createStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static final b3_6 = _createStyle(fontSize: 14, fontWeight: FontWeight.w600);

  // Button (14px)
  static final btn_4 = _createStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static final btn_5 = _createStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static final btn_6 = _createStyle(fontSize: 14, fontWeight: FontWeight.w600);

  // Label (14px)
  static final label_4 =
      _createStyle(fontSize: 14, fontWeight: FontWeight.w400);

  // Caption (12px)
  static final cap_4 = _createStyle(fontSize: 12, fontWeight: FontWeight.w400);

  // App Title (24px)
  static final appTitle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFeatures: _features,
      fontFamily: AppFonts.caveat,
      height: 1.2,
      leadingDistribution: TextLeadingDistribution.even);
}
