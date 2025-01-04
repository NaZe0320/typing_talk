import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_result.freezed.dart';

@freezed
class TypingResult with _$TypingResult {
  const factory TypingResult({
    required int accuracy,
    required int wpm,
    required int errorCount,
    required Duration timeSpent,
  }) = _TypingResult;
}
