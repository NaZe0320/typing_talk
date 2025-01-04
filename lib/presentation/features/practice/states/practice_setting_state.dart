import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/text_item.dart';

part 'practice_setting_state.freezed.dart';

@freezed
class PracticeSettingState with _$PracticeSettingState {
  const factory PracticeSettingState({
    @Default('practice') String practiceMode,
    @Default([]) List<int> selectedTexts,
    @Default([]) List<TextItem> availableTexts,
    @Default(false) bool isStartButtonEnabled,
    Duration? timeLimit,
  }) = _PracticeSettingState;
}
