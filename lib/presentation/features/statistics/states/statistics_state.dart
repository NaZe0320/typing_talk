import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';

part 'statistics_state.freezed.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default([]) List<TypingRecord> records,
    @Default(0.0) double averageSpeed,
    @Default(0.0) double averageAccuracy,
    @Default('week') String selectedPeriod,
    @Default(false) bool isLoading,
    String? error,
  }) = _StatisticsState;
}
