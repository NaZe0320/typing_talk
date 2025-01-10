import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_result_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

part 'practice_result_view_model.g.dart';

@riverpod
class PracticeResultViewModel extends _$PracticeResultViewModel {
  @override
  PracticeResultState build() {
    final practiceState = ref.watch(practiceViewModelProvider);

    return PracticeResultState(
      practiceMode: practiceState.practiceMode,
      elapsedSeconds: practiceState.elapsedSeconds,
      totalMessages: practiceState.allMessages.length,
      totalKeystrokes: practiceState.totalKeystrokes,
      accuracy: ref.read(practiceViewModelProvider.notifier).getAccuracy(),
      typingSpeed: ref.read(practiceViewModelProvider.notifier).getTypingSpeed(),
    );
  }
}
