import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_setting_view_model.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('연습 (채팅)');
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceSettingViewModelProvider);
    final viewModel = ref.read(practiceSettingViewModelProvider.notifier);

    return Container(
      color: Colors.white,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('연습 모드 : ${state.practiceMode}'),
          Text('선택한 글 : ${state.selectedTexts.toString()}'),
          //Text('가능한 글 : ${state.availableTexts.toString()}'),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.practiceResult);
                  },
                  child: Text('연습 (채팅) 화면')))
        ],
      ),
    );
  }

/*  @override
  Future<(bool, String?)> onWillPop(BuildContext context) async {
    context.go('/');
    return (false, null);
  }*/
}
