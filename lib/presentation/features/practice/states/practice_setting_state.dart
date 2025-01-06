import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/text_item.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';

part 'practice_setting_state.freezed.dart';

@freezed
class PracticeSettingState with _$PracticeSettingState {
  const factory PracticeSettingState({
    @Default(PracticeMode.practice) PracticeMode practiceMode,
    @Default([]) List<int> selectedTexts,
    @Default([]) List<TextItem> availableTexts,
    @Default(false) bool isStartButtonEnabled,
    Duration? timeLimit,
  }) = _PracticeSettingState;
}
