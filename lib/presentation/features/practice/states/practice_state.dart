import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    @Default([]) List<String> allMessages, // 전체 문장 목록
    @Default([]) List<TypingMessage> displayedMessages, // 화면에 표시된 문장들
    @Default(0) int currentMessageIndex, // 현재 입력해야 할 문장의 인덱스
    @Default('') String currentInput,
    @Default(PracticeMode.practice) PracticeMode practiceMode,
    @Default(false) bool isComplete,
    @Default([]) List<CharacterState> characterStates,
    @Default(0) int totalKeystrokes, // 총 타수
    @Default(0) int currentKeystrokes, //현재 문장 타수
    @Default(0) int totalCorrectKeystrokes, // 총 정확한 타수
    @Default(0) int currentCorrectKeystrokes, //현재 정확한 타수
    @Default(0) int elapsedSeconds, // 경과 시간
  }) = _PracticeState;
}
