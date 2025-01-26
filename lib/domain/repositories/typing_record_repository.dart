import 'package:typing_talk/domain/entities/typing_record.dart';

abstract class TypingRecordRepository {
  Future<void> saveRecord(TypingRecord record);
  Future<List<TypingRecord>> getRecords({int limit});
}
