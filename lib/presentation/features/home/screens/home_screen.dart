import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            HomeAppBar(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  Text('레벨', style: AppTypography.b3_6),
                  Text('데일리', style: AppTypography.b3_6),
                  TextButton(
                      onPressed: () {
                        print("이동");
                        context.pushNamed(RouteNames.practice);
                      },
                      child: Text('빠른 시작', style: AppTypography.b3_6)),
                  Text('통계', style: AppTypography.b3_6),
                  Text('Navigation Card', style: AppTypography.b3_6),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
