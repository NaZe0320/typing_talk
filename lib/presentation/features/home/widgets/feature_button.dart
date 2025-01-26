import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isFullWidth;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const FeatureButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isFullWidth = false,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96, // 모든 버튼의 높이를 96으로 통일
      child: Material(
        color: backgroundColor ??
            (isPrimary ? AppColors.primaryBlue : (isFullWidth ? Colors.white : AppColors.secondaryBlue)),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: !isPrimary && !isFullWidth
                ? null
                : BoxDecoration(
                    border: isFullWidth ? Border.all(color: AppColors.gray200) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: isFullWidth ? 16 : 12,
            ),
            width: isFullWidth ? double.infinity : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? (isPrimary ? Colors.white : AppColors.primaryBlue),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTypography.b2_5.copyWith(
                    color: textColor ?? (isPrimary ? Colors.white : AppColors.primaryText),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
