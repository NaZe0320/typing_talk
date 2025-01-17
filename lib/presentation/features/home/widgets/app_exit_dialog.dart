import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/base/base_dialog.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_button.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_text_button.dart';

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
        AppButton(
          onPressed: () {
            SystemNavigator.pop(); // 앱 종료
          },
          text: '종료',
        ),
        const SizedBox(height: 8),
        AppTextButton(
          onPressed: () => Navigator.of(context).pop(false),
          text: '취소',
        ),
      ],
    );
  }
}
