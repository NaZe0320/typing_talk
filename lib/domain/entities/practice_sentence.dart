import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_sentence.freezed.dart';

@freezed
class PracticeSentence with _$PracticeSentence {
  const factory PracticeSentence({
    required int textId,
    required List<String> sentences,
  }) = _PracticeSentence;
}
