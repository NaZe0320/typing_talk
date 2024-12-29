import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';

class PracticeSettingScreen extends BaseScreen {
  const PracticeSettingScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('연습 설정');
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
                  child: TextButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.practice);
                      },
                      child: Text('연습 설정 화면'))))
        ],
      ),
    );
  }
}
