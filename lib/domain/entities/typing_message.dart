import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_message.freezed.dart';

@freezed
class TypingMessage with _$TypingMessage {
  const factory TypingMessage({
    required String id,
    required String content,
    required bool isTarget, // true면 목표 문장, false면 사용자 입력
  }) = _TypingMessage;
}
