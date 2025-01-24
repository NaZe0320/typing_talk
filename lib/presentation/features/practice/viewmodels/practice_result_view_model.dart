import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/data/repositories/typing_record_repository_impl.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_result_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

part 'practice_result_view_model.g.dart';

@riverpod
class PracticeResultViewModel extends _$PracticeResultViewModel {
  final _repository = TypingRecordRepositoryImpl();

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

    _saveRecord(record);

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
      await _repository.saveRecord(record);
      AppLogger.info('타자 기록 저장 성공');
    } catch (e) {
      AppLogger.error('타자 기록 저장 실패: $e');
    }
  }

  Future<List<TypingRecord>> getRecentRecords({int limit = 10}) async {
    try {
      return await _repository.getRecords(limit: limit);
    } catch (e) {
      AppLogger.error('최근 기록 조회 실패: $e');
      return [];
    }
  }
}
