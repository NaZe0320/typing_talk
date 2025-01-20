import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/sentence_status.dart';
import 'package:typing_talk/domain/enums/sentence_type.dart';

part 'typing_message.freezed.dart';
part 'typing_message.g.dart';

@freezed
class TypingMessage with _$TypingMessage {
  const factory TypingMessage({
    required String content,
    @Default(SentenceType.prompt) SentenceType type,
    @Default(SentenceStatus.current) SentenceStatus status,
  }) = _TypingMessage;

  factory TypingMessage.fromJson(Map<String, dynamic> json) => _$TypingMessageFromJson(json);
}
