import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/core/theme/app_gradients.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/navigation_button.dart';
import 'package:typing_talk/presentation/features/home/widgets/app_exit_dialog.dart';
import 'package:typing_talk/presentation/features/home/widgets/feature_button.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

import 'dart:io';

import 'package:typing_talk/presentation/features/home/widgets/profile_widget.dart';
import 'package:typing_talk/presentation/features/home/widgets/resume_session_dialog.dart';
import 'package:typing_talk/presentation/features/practice/states/saved_practice_state.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const HomeAppBar();
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _checkSavedPractice(context);
      return null;
    }, []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // 레벨 진행 상태
                  _buildLevelProgress(),
                  const SizedBox(height: 16),
                  // 일일 퀘스트
                  _buildDailyQuest(),
                  const SizedBox(height: 16),
                  // 빠른 실행 버튼
                  _buildQuickActions(context),
                  const SizedBox(height: 16),
                  // 기능 그리드
                  _buildFeatureGrid(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<(bool, String?)> onWillPop(BuildContext context, WidgetRef ref) async {
    final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AppExitDialog(),
        ) ??
        false;

    if (shouldExit) {
      // 플랫폼 별 앱 종료 처리
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }

    return (false, null);
  }

  Widget _buildLevelProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '레벨 5',
              style: AppTypography.b2_6.copyWith(color: AppColors.primaryText),
            ),
            Text(
              '다음 레벨까지 230 XP',
              style: AppTypography.b3_4.copyWith(color: AppColors.secondaryText),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyQuest() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.premiumBlueGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.track_changes, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '오늘의 도전',
                    style: AppTypography.b2_6.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '300 XP',
                  style: AppTypography.b3_5.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '5분 연습 3회 완료하기',
            style: AppTypography.b3_4.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 0.33,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FeatureButton(
            icon: Icons.bolt,
            label: '연습 시작',
            isPrimary: true,
            onTap: () => context.pushNamed(RouteNames.practiceSetting),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FeatureButton(
            icon: Icons.emoji_events,
            label: '통계',
            onTap: () => context.pushNamed(RouteNames.statistic),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    const features = [
      {'icon': Icons.book, 'label': '글 목록', 'routeName': RouteNames.statistic},
      {'icon': Icons.shopping_bag, 'label': '상점', 'routeName': RouteNames.statistic},
      {'icon': Icons.military_tech, 'label': '업적', 'routeName': RouteNames.statistic},
      {'icon': Icons.settings, 'label': '설정', 'routeName': RouteNames.statistic},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: features
          .map(
            (feature) => FeatureButton(
              icon: feature['icon'] as IconData,
              label: feature['label'] as String,
              isFullWidth: true,
              onTap: () {
                context.pushNamed(feature['routeName'] as String);
              },
            ),
          )
          .toList(),
    );
  }
}

Future<void> _checkSavedPractice(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final hasSavedState = prefs.containsKey('saved_practice_state');

  if (hasSavedState) {
    final savedStateJson = prefs.getString('saved_practice_state');
    if (savedStateJson != null) {
      try {
        final savedState = SavedPracticeState.fromJson(
          jsonDecode(savedStateJson) as Map<String, dynamic>,
        );

        if (context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ResumeSessionDialog(
              savedState: savedState,
              onResume: () {
                if (context.mounted) {
                  context.pushNamed(RouteNames.practice);
                }
              },
              onNewSession: () async {
                await prefs.remove('saved_practice_state');
                if (context.mounted) {
                  context.pushNamed(RouteNames.practiceSetting);
                }
              },
            ),
          );
        }
      } catch (e) {
        // 저장된 상태가 유효하지 않은 경우 삭제
        await prefs.remove('saved_practice_state');
        AppLogger.error('저장 상태가 유효하지 않습니다 : $e');
      }
    }
  }
}
