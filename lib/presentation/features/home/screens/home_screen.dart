import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/presentation/common/widgets/buttons/navigation_button.dart';
import 'package:typing_talk/presentation/features/home/widgets/app_exit_dialog.dart';
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
