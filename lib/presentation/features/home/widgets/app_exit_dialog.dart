import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/base/base_dialog.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class AppExitDialog extends ConsumerWidget {
  const AppExitDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.exit_to_app_rounded,
          size: 32,
          color: AppColors.errorText,
        ),
      ),
      title: 'TypingTalk 종료',
      message: '앱을 종료하시겠습니까?',
      actions: [
        ElevatedButton(
          onPressed: () {
            SystemNavigator.pop(); // 앱 종료
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorText,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            '종료',
            style: AppTypography.btn_6.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            '취소',
            style: AppTypography.btn_6.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
