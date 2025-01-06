import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<TypingMessage> messages,
    @Default(0) int currentMessageIndex,
    @Default(0) int currentWPM,
    @Default(0.0) double accuracy,
    @Default(false) bool isCompleted,
    Duration? timeLimit,
    @Default(PracticeMode.practice) PracticeMode practiceMode,
  }) = _PracticeState;
}
