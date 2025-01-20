import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/data/repositories/typing_record_repository_impl.dart';
import 'package:typing_talk/presentation/features/statistics/states/statistics_state.dart';

part 'statistics_view_model.g.dart';

@riverpod
class StatisticsViewModel extends _$StatisticsViewModel {
  TypingRecordRepositoryImpl? _repository;

  @override
  StatisticsState build() {
    _initRepository();
    _loadRecords();
    return const StatisticsState();
  }

  Future<void> _initRepository() async {
    _repository = await TypingRecordRepositoryImpl.create();
  }

  Future<void> _loadRecords() async {
    state = state.copyWith(isLoading: true);

    try {
      final records = await _repository?.getRecords() ?? [];

      // 평균 계산
      final averageSpeed =
          records.isEmpty ? 0.0 : records.map((r) => r.typingSpeed).reduce((a, b) => a + b) / records.length;

      final averageAccuracy =
          records.isEmpty ? 0.0 : records.map((r) => r.accuracy).reduce((a, b) => a + b) / records.length;

      state = state.copyWith(
        records: records,
        averageSpeed: averageSpeed,
        averageAccuracy: averageAccuracy,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void updatePeriod(String period) {
    state = state.copyWith(selectedPeriod: period);
    _loadRecords();
  }
}
