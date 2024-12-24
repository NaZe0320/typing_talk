import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          HomeAppBar(),
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                //레벨
                //데일리
                //빠른 시작
                //통계
                //Navigation Card
              ],
            ),
          ))
        ],
      ),
    );
  }
}
