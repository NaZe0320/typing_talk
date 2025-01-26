import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'typing_record.freezed.dart';
part 'typing_record.g.dart';

@freezed
class TypingRecord with _$TypingRecord {
  const factory TypingRecord({
    String? id,
    required PracticeMode mode,
    required int elapsedSeconds,
    required int totalMessages,
    required int totalKeystrokes,
    required double accuracy,
    required double typingSpeed,
    required DateTime createdAt,
  }) = _TypingRecord;

  factory TypingRecord.fromJson(Map<String, dynamic> json) => _$TypingRecordFromJson(json);
}
