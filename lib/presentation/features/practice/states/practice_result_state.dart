import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_result_state.freezed.dart';

@freezed
class PracticeResultState with _$PracticeResultState {
  const factory PracticeResultState({
    @Default(PracticeMode.practice) PracticeMode practiceMode,
    @Default(0) int elapsedSeconds,
    @Default(0) int totalMessages,
    @Default(0) int totalKeystrokes,
    @Default(0) double accuracy,
    @Default(0) double typingSpeed,
  }) = _PracticeResultState;
}
