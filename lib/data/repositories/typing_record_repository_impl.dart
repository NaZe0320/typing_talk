import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/core/utils/storage_manager.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/domain/repositories/typing_record_repository.dart';

class TypingRecordRepositoryImpl implements TypingRecordRepository {
  static const String _recordListKey = 'typingRecordList';

  @override
  Future<void> saveRecord(TypingRecord record) async {
    try {
      List<TypingRecord> existingRecords = await getRecords();
      existingRecords.insert(0, record);

      final recordMaps = existingRecords.map((record) => record.toJson()).toList();

      await StorageManager.saveUserData(_recordListKey, recordMaps);
    } catch (e) {
      AppLogger.error('타자 기록 저장 실패: $e');
      rethrow;
    }
  }

  @override
  Future<List<TypingRecord>> getRecords({int? limit}) async {
    try {
      final recordMaps = StorageManager.getUserData<List>(_recordListKey);
      if (recordMaps == null) return [];

      List<TypingRecord> records =
          recordMaps.map((map) => TypingRecord.fromJson(Map<String, dynamic>.from(map))).toList();

      return limit != null ? records.take(limit).toList() : records;
    } catch (e) {
      AppLogger.error('타자 기록 조회 실패: $e');
      return [];
    }
  }
}
