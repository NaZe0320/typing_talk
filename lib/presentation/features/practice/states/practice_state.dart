import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<TypingMessage> allMessages, // 전체 문장 목록
    @Default([]) List<TypingMessage> visibleMessages, // 화면에 표시된 문장들
    @Default(0) int currentMessageIndex, // 현재 입력해야 할 문장의 인덱스
    @Default(0) int currentWPM,
    @Default(0.0) double accuracy,
    @Default(false) bool isCompleted,
    Duration? timeLimit,
    @Default(PracticeMode.practice) PracticeMode practiceMode,
  }) = _PracticeState;
}
