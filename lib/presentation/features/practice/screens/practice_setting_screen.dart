import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/core/theme/app_gradients.dart';
import 'package:typing_talk/domain/entities/text_item.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_setting_view_model.dart';

class PracticeSettingScreen extends BaseScreen {
  const PracticeSettingScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('연습 설정');
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceSettingViewModelProvider);
    final viewModel = ref.read(practiceSettingViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSectionTitle('연습 모드', Icons.book),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModeButton(
                          title: '타자 연습',
                          subtitle: '시간 제한 없음',
                          icon: Icons.message,
                          isSelected: state.practiceMode == 'practice',
                          onTap: () => viewModel.togglePracticeMode('practice'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModeButton(
                          title: '타자 검정',
                          subtitle: '5분 제한',
                          icon: Icons.timer,
                          isSelected: state.practiceMode == 'test',
                          onTap: () => viewModel.togglePracticeMode('test'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Text Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('글 선택', Icons.book),
                      Text(
                        '${state.selectedTexts.length}개 선택됨',
                        style: AppTypography.b3_4.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...state.availableTexts.map((text) => _buildTextItem(
                        text: text,
                        isSelected: state.selectedTexts.contains(text.id),
                        onTap: () => viewModel.toggleTextSelection(text.id),
                      )),
                  const SizedBox(height: 24),
                  // AI Feature Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppGradients.premiumGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              color: AppColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI 맞춤 문장 생성',
                              style: AppTypography.b2_6.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI가 생성한 맞춤형 문장으로 연습해보세요.',
                          style: AppTypography.b3_4.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // Handle premium upgrade
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            minimumSize: const Size(double.infinity, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            '프리미엄으로 업그레이드',
                            style: AppTypography.btn_5.copyWith(
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed(RouteNames.practice);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '시작하기',
                style: AppTypography.btn_6.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.b2_6,
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.gray400,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.b3_5.copyWith(
                color: isSelected ? AppColors.primaryBlue : AppColors.gray500,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.cap_4.copyWith(
                color: AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem({
    required TextItem text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryBlue : AppColors.surface,
          border: isSelected ? Border.all(color: AppColors.primaryBlue, width: 2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text.title,
                    style: AppTypography.b3_5.copyWith(
                      color: isSelected ? AppColors.primaryBlue : AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTag(text.difficulty),
                      const SizedBox(width: 8),
                      _buildTag(text.length),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTypography.cap_4.copyWith(
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
