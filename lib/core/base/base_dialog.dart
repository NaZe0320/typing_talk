import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class BaseDialog extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget>? content;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final bool barrierDismissible;
  final double? width;

  const BaseDialog({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.padding,
    this.width,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: width ?? 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: padding ??
                  const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 12,
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(height: 16),
                  ],
                  if (title != null) ...[
                    Text(
                      title!,
                      style: AppTypography.h3_6.copyWith(
                        color: AppColors.primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (message != null) ...[
                    Text(
                      message!,
                      style: AppTypography.b2_4.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (content != null) ...content!,
                ],
              ),
            ),
            if (actions != null) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
