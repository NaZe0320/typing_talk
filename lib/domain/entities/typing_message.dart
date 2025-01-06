import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/character_state.dart';

part 'typing_message.freezed.dart';

@freezed
class TypingMessage with _$TypingMessage {
  const factory TypingMessage({
    required String id,
    required String content, // 제시 문장
    String? userInput, // 사용자 입력
    @Default(false) bool isCompleted, // 입력 완료 여부
    @Default([]) List<CharacterState> characterStates, // 각 문자의 상태
    @Default(0) int cursorPosition, // 현재 입력 위치
  }) = _TypingMessage;
}
