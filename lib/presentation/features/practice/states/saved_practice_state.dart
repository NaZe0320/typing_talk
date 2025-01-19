import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'saved_practice_state.freezed.dart';
part 'saved_practice_state.g.dart';

@freezed
class SavedPracticeState with _$SavedPracticeState {
  const factory SavedPracticeState({
    required List<String> allMessages,
    required List<String> displayedMessages,
    required PracticeMode practiceMode,
    required int currentMessageIndex,
    required int elapsedSeconds,
    required String currentInput,
    required int totalKeystrokes,
    required int actualTotalKeystrokes,
    required int totalCorrectKeystrokes,
    required DateTime savedAt,
  }) = _SavedPracticeState;

  factory SavedPracticeState.fromJson(Map<String, dynamic> json) => _$SavedPracticeStateFromJson(json);
}
