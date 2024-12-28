import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';

class StatisticScreen extends ConsumerWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              DefaultAppBar('통계'),
              Expanded(
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            context.go('/');
                          },
                          child: Text('통계 화면'))))
            ],
          ),
        ),
      ),
    );
  }
}
