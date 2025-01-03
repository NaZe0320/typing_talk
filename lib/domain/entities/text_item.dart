import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_item.freezed.dart';

@freezed
class TextItem with _$TextItem {
  const factory TextItem({
    required int id,
    required String title,
    required String difficulty,
    required String length,
  }) = _TextItem;
}
