import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/constants/practice_options.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';
import 'package:typing_talk/presentation/features/practice/widgets/select_group.dart';

class PracticeSettingScreen extends BaseScreen {
  const PracticeSettingScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('연습 설정');
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final practiceState = ref.watch(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              spacing: 24,
              children: [
                SelectGroup(
                  label: '연습 모드',
                  options: PracticeOptions.modeOptions,
                  selectionType: SelectionType.single,
                  initialValue: practiceState.selectedMode,
                  onChanged: viewModel.selectMode,
                ),
                SelectGroup(
                  label: '시간 설정',
                  options: PracticeOptions.timeOptions,
                  selectionType: SelectionType.single,
                  initialValue: practiceState.selectedTimeLimit,
                  onChanged: viewModel.selectTimeLimit,
                ),
                SelectGroup(
                  label: '주제 선택 (다중 선택 가능)',
                  options: PracticeOptions.topicOptions,
                  selectionType: SelectionType.multiple,
                  initialValues: practiceState.selectedTopics,
                  onMultiChanged: viewModel.setTopics,
                ),
              ],
            ),
          ),
          Text('${practiceState.selectedMode}\n${practiceState.selectedTimeLimit}\n${practiceState.selectedTopics}'),
          Center(
              child: TextButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.practice);
                  },
                  child: Text('연습 설정 화면')))
        ],
      ),
    );
  }
}
