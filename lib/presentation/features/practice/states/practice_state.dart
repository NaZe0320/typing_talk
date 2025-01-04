import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<TypingMessage> messages,
    Duration? timeLimit,
    @Default('practice') String practiceMode,
  }) = _PracticeState;
}
