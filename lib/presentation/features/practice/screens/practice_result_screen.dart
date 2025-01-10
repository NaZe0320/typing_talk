import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/core/theme/app_gradients.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_result_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_result_view_model.dart';

class PracticeResultScreen extends BaseScreen {
  const PracticeResultScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('연습 결과');
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceResultViewModelProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreCard(state),
            const SizedBox(height: 16),
            _buildDetailStats(state),
            const SizedBox(height: 16),
            //_buildAccuracyAnalysis(state),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(PracticeResultState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.premiumBlueGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 48,
            color: AppColors.white,
          ),
          const SizedBox(height: 16),
          Text(
            '${state.accuracy.toStringAsFixed(1)}점',
            style: AppTypography.h1_7.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '상위 15%의 성과입니다!',
            style: AppTypography.b3_4.copyWith(color: AppColors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: _buildScoreItem('평균 타수', '${state.typingSpeed.toStringAsFixed(1)} 타'),
              ),
              Expanded(
                child: _buildScoreItem('정확도', '${state.accuracy.toStringAsFixed(1)}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.b3_4.copyWith(color: AppColors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.h3_6.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStats(PracticeResultState state) {
    final timeStr = '${(state.elapsedSeconds / 60).floor()}:${(state.elapsedSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상세 통계', style: AppTypography.b2_6),
          const SizedBox(height: 16),
          _buildStatRow('총 연습 시간', timeStr),
          _buildStatRow('총 문장 수', '${state.totalMessages}문장'),
          _buildStatRow('총 타수', '${state.totalKeystrokes}타'),
          _buildStatRow('분당 타수', '${state.typingSpeed.toStringAsFixed(1)}타'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.b3_4.copyWith(color: AppColors.secondaryText)),
          Text(value, style: AppTypography.b3_5),
        ],
      ),
    );
  }

  Widget _buildAccuracyAnalysis(PracticeResultState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('정확도 분석', style: AppTypography.b2_6),
          // 여기에 정확도 차트나 상세 분석을 추가할 수 있습니다
        ],
      ),
    );
  }

  @override
  Future<(bool, String?)> onWillPop(BuildContext context) async {
    context.go('/');
    return (false, null);
  }
}
