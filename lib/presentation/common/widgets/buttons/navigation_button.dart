import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton(this.text, {super.key, required this.onTap, required this.icon});

  final String text;
  final VoidCallback onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.defaultBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Ink(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    if (icon != null) IconWidget(assetName: icon!, size: 24),
                    Text(
                      text,
                      style: AppTypography.btn_6,
                    ),
                  ],
                ),
                IconWidget(assetName: 'arrow_right', size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
