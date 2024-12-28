import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const HomeAppBar();
  }

  @override
  Future<bool> onWillPop(BuildContext context, WidgetRef ref) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('종료'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.profile);
                  },
                  child: Text('프로필', style: AppTypography.b3_6),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.practiceSetting);
                  },
                  child: Text('빠른 시작', style: AppTypography.b3_6),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.statistic);
                  },
                  child: Text('통계', style: AppTypography.b3_6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
