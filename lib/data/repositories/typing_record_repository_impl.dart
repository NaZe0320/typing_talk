import 'package:hive_flutter/hive_flutter.dart';
import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/domain/entities/typing_record.dart';
import 'package:typing_talk/domain/repositories/typing_record_repository.dart';
import 'package:uuid/uuid.dart';

class TypingRecordRepositoryImpl implements TypingRecordRepository {
  static const String _boxName = 'typing_records';
  late Box<Map> _box;

  static TypingRecordRepositoryImpl? _instance;

  static Future<TypingRecordRepositoryImpl> create() async {
    if (_instance == null) {
      final repository = TypingRecordRepositoryImpl._();
      await repository._initialize();
      _instance = repository;
    }
    return _instance!;
  }

  TypingRecordRepositoryImpl._();

  Future<void> _initialize() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map>(_boxName);
    } else {
      _box = Hive.box<Map>(_boxName);
    }
  }

  @override
  Future<void> saveRecord(TypingRecord record) async {
    final id = const Uuid().v4();
    final recordWithId = record.copyWith(id: id);
    await _box.put(id, recordWithId.toJson());

    AppLogger.info('기록 저장: ${recordWithId.toJson()}'); // 로그 추가
  }

  @override
  Future<List<TypingRecord>> getRecords({int limit = 10}) async {
    final records = _box.values.map((json) => TypingRecord.fromJson(Map<String, dynamic>.from(json))).toList();

    // 날짜순 정렬
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final limitedRecords = records.take(limit).toList();
    AppLogger.info('기록 조회: [${limitedRecords.length}] records: ${limitedRecords.first}'); // 로그 추가
    return limitedRecords;
  }
}
