import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_dialog.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_button.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/app_text_button.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

class ExitPracticeDialog extends ConsumerWidget {
  const ExitPracticeDialog({
    super.key,
    required this.practiceTime,
    required this.onExit,
    required this.onContinue,
  });

  final Duration practiceTime;
  final VoidCallback onExit;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    return BaseDialog(
      icon: const Icon(
        Icons.warning_rounded,
        size: 48,
        color: AppColors.primaryBlue,
      ),
      title: '연습을 종료하시겠습니까?',
      content: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            spacing: 8,
            children: [
              _buildInfoRow(
                Icons.timer_outlined,
                '진행 시간',
                '${practiceTime.inMinutes}분 ${practiceTime.inSeconds % 60}초',
              ),
              _buildInfoRow(
                Icons.save_outlined,
                '완료한 문장',
                '${state.currentMessageIndex}/${state.allMessages.length}개',
              ),
              _buildInfoRow(
                Icons.speed_outlined,
                '현재 정확도',
                '${viewModel.getAccuracy().toStringAsFixed(1)}%',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '지금까지의 연습 결과가 저장되며,\n결과 화면에서 확인하실 수 있습니다.',
          style: AppTypography.b2_4.copyWith(
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      actions: [
        AppButton(
          onPressed: () {
            Navigator.of(context).pop();
            viewModel.completePractice(); // 연습 완료 처리
            context.pushNamed(RouteNames.practiceResult); // 결과 화면으로 이동
          },
          text: '종료하고 결과 보기',
        ),
        const SizedBox(height: 8),
        AppTextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onContinue();
          },
          text: '계속 연습하기',
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
