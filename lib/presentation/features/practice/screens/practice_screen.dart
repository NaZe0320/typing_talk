import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/constants/app_constant.dart';
import 'package:typing_talk/core/lifecycle/lifecycle_hook.dart';
import 'package:typing_talk/core/routes/route_names.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';
import 'package:typing_talk/presentation/features/practice/widgets/exit_practice_dialog.dart';
import 'package:typing_talk/presentation/features/practice/widgets/message_list.dart';
import 'package:typing_talk/presentation/features/practice/widgets/stat_item.dart';
import 'package:typing_talk/presentation/features/practice/widgets/typing_input.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);

    final Color modeColor = state.practiceMode == PracticeMode.practice ? AppColors.primaryBlue : AppColors.errorText;

    return Container(
      height: AppConstant.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          spacing: 8,
          children: [
            IconWidget(assetName: 'arrow_left', size: 24, onTap: () => showExitPracticeDialog(context, ref)),
            Text(state.practiceMode == PracticeMode.practice ? '타자연습' : '타자검정', style: AppTypography.h3_6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: modeColor.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: modeColor.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: modeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state.practiceMode == PracticeMode.practice
                        ? '${(state.elapsedSeconds / 60).toInt()}:${(state.elapsedSeconds % 60).toString().padLeft(2, '0')}'
                        : '${((300 - state.elapsedSeconds) / 60).toInt()}:${((300 - state.elapsedSeconds) % 60).toString().padLeft(2, '0')}',
                    style: AppTypography.b3_6.copyWith(
                      color: modeColor,
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

  void showExitPracticeDialog(BuildContext context, WidgetRef ref) {
    final state = ref.read(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    viewModel.pausePractice();

    showDialog(
      context: context,
      barrierDismissible: false, // 백그라운드 탭으로 닫히지 않도록 설정
      builder: (context) => ExitPracticeDialog(
        practiceTime: Duration(seconds: state.elapsedSeconds),
        onExit: () {
          viewModel.completePractice();
          context.go('/'); // 홈으로 이동
        },
        onContinue: () {
          viewModel.resumePractice();
        },
      ),
    );
  }

  @override
  Future<(bool, String?)> onWillPop(BuildContext context, WidgetRef ref) async {
    showExitPracticeDialog(context, ref);
    return (false, null);
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    useEffect(() {
      viewModel.initializeState().then((_) {
        viewModel.startPractice();
      });
      return null;
    }, []);

    useAppLifecycle(ref, (state) {
      switch (state) {
        case AppLifecycleState.resumed:
          viewModel.resumePractice();
          // 예: 데이터 새로고침
          break;
        case AppLifecycleState.inactive:
          viewModel.pausePractice(); // 현재 상태 저장
          break;
        case AppLifecycleState.paused:
          viewModel.pausePractice(); // 현재 상태 저장
          break;
        case AppLifecycleState.detached:
          break;
        case AppLifecycleState.hidden:
          throw UnimplementedError();
      }
    });

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
                value: '${viewModel.getTypingSpeed().toStringAsFixed(1)}타',
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
          initialText: state.currentInput,
        ),
      ],
    );
  }
}
