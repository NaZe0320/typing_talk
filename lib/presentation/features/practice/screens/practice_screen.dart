import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/constants/app_constant.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';
import 'package:typing_talk/presentation/features/practice/widgets/message_list.dart';
import 'package:typing_talk/presentation/features/practice/widgets/stat_item.dart';
import 'package:typing_talk/presentation/features/practice/widgets/typing_input.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    return Container(
      height: AppConstant.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          spacing: 8,
          children: [
            IconWidget(assetName: 'arrow_left', size: 24, onTap: () => context.go('/')),
            Text(state.practiceMode == PracticeMode.practice ? '타자연습' : '타자검정', style: AppTypography.h3_6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(state.elapsedSeconds / 60).toInt()}:${(state.elapsedSeconds % 60).toString().padLeft(2, '0')}',
                    style: AppTypography.b3_6.copyWith(
                      color: AppColors.primaryBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
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

    useEffect(() {
      viewModel.startPractice();
      return null;
    }, const []);

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
              StatItem(
                label: '정확도',
                value: '${viewModel.getAccuracy().toStringAsFixed(1)}%',
              ),
              StatItem(
                label: '타수',
                value: '${viewModel.getTypingSpeed().toInt()}타',
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
