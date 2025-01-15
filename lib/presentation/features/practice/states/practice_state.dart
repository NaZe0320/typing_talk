import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<String> allMessages,
    @Default([]) List<TypingMessage> displayedMessages,
    @Default(0) int currentMessageIndex,
    @Default('') String currentInput,
    @Default(PracticeMode.practice) PracticeMode practiceMode,
    @Default(false) bool isComplete,
    @Default([]) List<CharacterState> characterStates,
    @Default(0) int totalKeystrokes, // 정확도 계산용 전체 타수 (미입력 포함)
    @Default(0) int currentKeystrokes,
    @Default(0) int totalCorrectKeystrokes,
    @Default(0) int currentCorrectKeystrokes,
    @Default(0) int elapsedSeconds,
    @Default(0) int actualTotalKeystrokes, // 속도 계산용 실제 입력 타수
  }) = _PracticeState;
}
