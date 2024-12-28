import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';

class PracticeSettingScreen extends ConsumerWidget {
  const PracticeSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              DefaultAppBar('연습 설정'),
              Expanded(
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.practice);
                          },
                          child: Text('연습 설정 화면'))))
            ],
          ),
        ),
      ),
    );
  }
}
