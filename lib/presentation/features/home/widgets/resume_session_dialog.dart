import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/base/base_dialog.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_button.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_text_button.dart';
import 'package:typing_talk/presentation/features/practice/states/saved_practice_state.dart';

class ResumeSessionDialog extends ConsumerWidget {
  const ResumeSessionDialog({
    super.key,
    required this.savedState,
    required this.onResume,
    required this.onNewSession,
  });

  final SavedPracticeState savedState;
  final VoidCallback onResume;
  final VoidCallback onNewSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      icon: const Icon(
        Icons.restore_rounded,
        size: 48,
        color: AppColors.primaryBlue,
      ),
      title: '이전 연습 이어하기',
      content: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.timer_outlined,
                '진행 시간',
                '${savedState.elapsedSeconds ~/ 60}분 ${savedState.elapsedSeconds % 60}초',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.save_outlined,
                '완료한 문장',
                '${savedState.currentMessageIndex}/${savedState.allMessages.length}개',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '저장된 연습 기록이 있습니다.\n이어서 연습하시겠습니까?',
          style: AppTypography.b2_4.copyWith(
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      actions: [
        AppButton(
          onPressed: () async {
            Navigator.of(context).pop();
            onResume();
          },
          text: '이어서 연습하기',
        ),
        const SizedBox(height: 8),
        AppTextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNewSession();
          },
          text: '새로 시작하기',
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.blueText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.b3_5.copyWith(
                color: AppColors.blueText,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTypography.b3_6.copyWith(
            color: AppColors.blueText,
          ),
        ),
      ],
    );
  }
}
