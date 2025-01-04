import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/entities/typing_result.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<TypingMessage> messages,
    @Default(false) bool isCompleted,
    @Default(0) int currentMessageIndex,
    String? currentInput,
    @Default(false) bool showRealTimeFeedback,
    Duration? remainingTime, // null이면 타자연습 모드
    @Default(0) int currentWPM,
    @Default(0.0) double accuracy,
  }) = _PracticeState;
}
