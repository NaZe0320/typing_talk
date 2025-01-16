import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/navigation_button.dart';
import 'package:typing_talk/presentation/features/home/widgets/app_exit_dialog.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

import 'dart:io';

import 'package:typing_talk/presentation/features/home/widgets/profile_widget.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const HomeAppBar();
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  ProfileWidget(),
                  NavigationButton(
                    '빠른 시작',
                    icon: 'chat',
                    onTap: () {
                      context.pushNamed(RouteNames.practice);
                    },
                  ),
                  NavigationButton(
                    '연습하기',
                    icon: 'chat',
                    onTap: () {
                      context.pushNamed(RouteNames.practiceSetting);
                    },
                  ),
                  NavigationButton(
                    '통계',
                    icon: 'trophy',
                    onTap: () {
                      context.pushNamed(RouteNames.statistic);
                    },
                  ),
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
}
