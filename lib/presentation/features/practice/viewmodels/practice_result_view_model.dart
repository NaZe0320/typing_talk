import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/data/repositories/typing_record_repository_impl.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_result_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

part 'practice_result_view_model.g.dart';

@riverpod
class PracticeResultViewModel extends _$PracticeResultViewModel {
  TypingRecordRepositoryImpl? _repository;

  @override
  PracticeResultState build() {
    final practiceState = ref.watch(practiceViewModelProvider);

    final record = TypingRecord(
      mode: practiceState.practiceMode,
      elapsedSeconds: practiceState.elapsedSeconds,
      totalMessages: practiceState.allMessages.length,
      totalKeystrokes: practiceState.totalKeystrokes,
      accuracy: ref.read(practiceViewModelProvider.notifier).getAccuracy(),
      typingSpeed: ref.read(practiceViewModelProvider.notifier).getTypingSpeed(),
      createdAt: DateTime.now(),
    );

    TypingRecordRepositoryImpl.create().then((repo) {
      _repository = repo;
      _saveRecord(record);

      getRecentRecords();
    });

    return PracticeResultState(
      practiceMode: practiceState.practiceMode,
      elapsedSeconds: practiceState.elapsedSeconds,
      totalMessages: practiceState.allMessages.length,
      totalKeystrokes: practiceState.totalKeystrokes,
      accuracy: ref.read(practiceViewModelProvider.notifier).getAccuracy(),
      typingSpeed: ref.read(practiceViewModelProvider.notifier).getTypingSpeed(),
    );
  }

  Future<void> _saveRecord(TypingRecord record) async {
    try {
      if (_repository != null) {
        await _repository?.saveRecord(record);
      } else {}
    } catch (e) {
      AppLogger.error('기록 저장 실패: $e');
    }
  }

  Future<List<TypingRecord>> getRecentRecords({int limit = 10}) async {
    try {
      final record = await _repository?.getRecords(limit: limit) ?? [];
      return record;
    } catch (e) {
      AppLogger.error('기록 조회 실패: $e');
      return [];
    }
  }
}
