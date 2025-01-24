import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_collection.freezed.dart';

@freezed
class TextCollection with _$TextCollection {
  const factory TextCollection({
    required int id,
    required String title,
    required String difficulty,
    required List<String> sentences,
  }) = _TextCollection;
}
