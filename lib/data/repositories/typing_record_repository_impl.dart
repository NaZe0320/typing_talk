import 'package:hive_flutter/hive_flutter.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/core/utils/storage_manager.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/domain/repositories/typing_record_repository.dart';
import 'package:uuid/uuid.dart';

class TypingRecordRepositoryImpl implements TypingRecordRepository {
  static const String _recordsKey = 'typing_records';
  static TypingRecordRepositoryImpl? _instance;

  TypingRecordRepositoryImpl._();

  static Future<TypingRecordRepositoryImpl> create() async {
    if (_instance == null) {
      final repository = TypingRecordRepositoryImpl._();
      await repository._initialize();
      _instance = repository;
    }
    return _instance!;
  }

  // 초기화 메서드
  Future<void> _initialize() async {
    try {
      // StorageManager가 초기화되어 있지 않다면 초기화
      if (StorageManager.getUserData<List>(_recordsKey) == null) {
        await StorageManager.saveUserData(_recordsKey, []);
      }
    } catch (e) {
      AppLogger.error('TypingRecordRepository 초기화 실패: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveRecord(TypingRecord record) async {
    try {
      final id = const Uuid().v4();
      final recordWithId = record.copyWith(id: id);

      // 기존 기록 불러오기
      final records = await getRecords();

      // 새 기록 추가
      records.insert(0, recordWithId);

      // 저장
      await StorageManager.saveUserData(_recordsKey, records.map((record) => record.toJson()).toList());

      AppLogger.info('타자 기록 저장 완료: ${recordWithId.id}');
    } catch (e) {
      AppLogger.error('타자 기록 저장 실패: $e');
      rethrow;
    }
  }

  @override
  Future<List<TypingRecord>> getRecords({int limit = 10}) async {
    try {
      // 저장된 JSON 데이터 가져오기
      final jsonList = StorageManager.getUserData<List>(_recordsKey) ?? [];

      // TypingRecord 객체로 변환
      final records = jsonList.map((json) => TypingRecord.fromJson(Map<String, dynamic>.from(json))).toList();

      // 날짜순 정렬
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // limit 적용
      final limitedRecords = records.take(limit).toList();

      AppLogger.info('타자 기록 조회 완료: ${limitedRecords.length}개');
      return limitedRecords;
    } catch (e) {
      AppLogger.error('타자 기록 조회 실패: $e');
      return [];
    }
  }

  // 모든 기록 삭제
  Future<void> clearAllRecords() async {
    try {
      await StorageManager.saveUserData(_recordsKey, []);
      AppLogger.info('모든 타자 기록 삭제 완료');
    } catch (e) {
      AppLogger.error('타자 기록 전체 삭제 실패: $e');
      rethrow;
    }
  }
}
