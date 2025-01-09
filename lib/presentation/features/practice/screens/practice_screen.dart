import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';
import 'package:typing_talk/presentation/features/practice/widgets/message_list.dart';
import 'package:typing_talk/presentation/features/practice/widgets/stat_item.dart';
import 'package:typing_talk/presentation/features/practice/widgets/typing_input.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    return DefaultAppBar(state.practiceMode == PracticeMode.practice ? '타자연습' : '타자검정');
  }

  @override
  Future<(bool, String?)> onWillPop(BuildContext context) async {
    context.go('/');
    return (false, null);
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    ref.listen(practiceViewModelProvider, (previous, next) {
      if (next.isComplete) {
        context.pushNamed(RouteNames.practiceResult);
      }
    });

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            border: Border(
              top: BorderSide(color: AppColors.defaultBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                label: '진행률',
                value: '${state.currentMessageIndex + 1}/${state.allMessages.length}',
              ),
            ],
          ),
        ),
        Expanded(
          child: MessageList(messages: state.displayedMessages),
        ),
        TypingInput(
          onChanged: viewModel.onTextInput,
          onSubmit: viewModel.handleSubmit,
          targetContent: "",
        ),
      ],
    );
  }
}
