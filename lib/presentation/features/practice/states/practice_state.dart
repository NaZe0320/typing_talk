import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_state.freezed.dart';

@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    String? selectedMode,
    String? selectedTimeLimit,
    @Default([]) List<String> selectedTopics,
    @Default(false) bool isValid,
  }) = _PracticeState;
}
