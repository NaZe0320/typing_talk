import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/data/repositories/typing_record_repository_impl.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/presentation/features/statistics/states/statistics_state.dart';

part 'statistics_view_model.g.dart';

@riverpod
class StatisticsViewModel extends _$StatisticsViewModel {
  final _repository = TypingRecordRepositoryImpl();
  Timer? _refreshTimer;

  @override
  StatisticsState build() {
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    _loadRecords();
    return const StatisticsState();
  }

  Future<void> _loadRecords() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final now = DateTime.now();
      final records = await _repository.getRecords();

      // 선택된 기간에 따라 필터링
      final filteredRecords = records.where((record) {
        final recordDate = record.createdAt;
        switch (state.selectedPeriod) {
          case 'week':
            return now.difference(recordDate).inDays <= 7;
          case 'month':
            return now.difference(recordDate).inDays <= 30;
          case 'year':
            return now.difference(recordDate).inDays <= 365;
          default:
            return true;
        }
      }).toList();

      // 평균 계산
      final averageSpeed = filteredRecords.isEmpty
          ? 0.0
          : filteredRecords.map((r) => r.typingSpeed).reduce((a, b) => a + b) / filteredRecords.length;

      final averageAccuracy = filteredRecords.isEmpty
          ? 0.0
          : filteredRecords.map((r) => r.accuracy).reduce((a, b) => a + b) / filteredRecords.length;

      state = state.copyWith(
        records: filteredRecords,
        averageSpeed: averageSpeed,
        averageAccuracy: averageAccuracy,
        isLoading: false,
      );

      AppLogger.info('통계 데이터 로드 성공: ${filteredRecords.length}개의 기록');
    } catch (e) {
      AppLogger.error('통계 데이터 로드 실패: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updatePeriod(String period) async {
    state = state.copyWith(selectedPeriod: period);
    await _loadRecords();
  }

  void refresh() {
    _loadRecords();
  }
}
