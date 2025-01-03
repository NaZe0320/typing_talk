import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_state.dart';

part 'practice_view_model.g.dart';

@riverpod
class PracticeViewModel extends _$PracticeViewModel {
  @override
  PracticeState build() {
    return const PracticeState();
  }

  void selectMode(String? mode) {
    state = state.copyWith(
      selectedMode: mode,
      isValid: _checkValidity(
        mode: mode,
        timeLimit: state.selectedTimeLimit,
        topics: state.selectedTopics,
      ),
    );
  }

  void selectTimeLimit(String? timeLimit) {
    state = state.copyWith(
      selectedTimeLimit: timeLimit,
      isValid: _checkValidity(
        mode: state.selectedMode,
        timeLimit: timeLimit,
        topics: state.selectedTopics,
      ),
    );
  }

  void toggleTopic(String topicId) {
    final currentTopics = List<String>.from(state.selectedTopics);
    if (currentTopics.contains(topicId)) {
      currentTopics.remove(topicId);
    } else {
      currentTopics.add(topicId);
    }

    state = state.copyWith(
      selectedTopics: currentTopics,
      isValid: _checkValidity(
        mode: state.selectedMode,
        timeLimit: state.selectedTimeLimit,
        topics: currentTopics,
      ),
    );
  }

  void setTopics(List<String> topics) {
    state = state.copyWith(
      selectedTopics: topics,
      isValid: _checkValidity(
        mode: state.selectedMode,
        timeLimit: state.selectedTimeLimit,
        topics: topics,
      ),
    );
  }

  bool _checkValidity({
    String? mode,
    String? timeLimit,
    List<String>? topics,
  }) {
    return mode != null && timeLimit != null && (topics?.isNotEmpty ?? false);
  }

  void resetSelections() {
    state = const PracticeState();
  }
}
