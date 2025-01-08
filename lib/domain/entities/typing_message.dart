import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/character_state.dart';

part 'typing_message.freezed.dart';

enum SentenceType { prompt, submitted }

enum SentenceStatus { current, completed }

@freezed
class TypingMessage with _$TypingMessage {
  const factory TypingMessage({
    required String content,
    @Default(SentenceType.prompt) SentenceType type,
    @Default(SentenceStatus.current) SentenceStatus status,
  }) = _TypingMessage;
}
