import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/features/home/widgets/home_app_bar.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [HomeAppBar(), Expanded(child: Text('연습화면'))],
      ),
    );
  }
}
