import 'package:typing_talk/core/utils/app_logger.dart';
import 'package:typing_talk/core/utils/storage_manager.dart';
import 'package:typing_talk/data/models/text_collection_model.dart';
import 'package:typing_talk/domain/repositories/text_collection_repository.dart';

class TextCollectionRepositoryImpl implements TextCollectionRepository {
  @override
  List<String> getTextCollectionByTextId(int textId) {
    final box = StorageManager.textCollectionBox;
    final collection = box.values.firstWhere(
      (collection) => collection.id == textId,
      orElse: () => null,
    );
    return collection?.sentences ?? [];
  }

  Future<void> initialize() async {
    try {
      final box = StorageManager.textCollectionBox;

      if (box.isEmpty) {
        final defaultCollections = [
          TextCollectionModel(
              id: 1,
              title: "일상 대화",
              sentences: [
                "안녕하세요, 오늘 날씨가 참 좋네요.",
                "주말에는 주로 어떤 것을 하면서 시간을 보내시나요?",
                "이번 주말에 영화 보러 가실래요?",
                "커피 한잔 마시면서 이야기 나눠요.",
              ],
              description: '일상 대화 목록'),
        ];

        // 데이터 저장
        await Future.forEach(defaultCollections, (TextCollectionModel collection) async {
          await box.add(collection);
        });
        AppLogger.info('TextCollection 기본 데이터 초기화 완료');
      }
    } catch (e) {
      AppLogger.error('TextCollection 초기화 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 모든 텍스트 컬렉션 조회
  List<TextCollectionModel> getAllCollections() {
    return StorageManager.textCollectionBox.values.map((dynamic item) => item as TextCollectionModel).toList();
  }

  /// 새로운 컬렉션 추가
  Future<void> addCollection(TextCollectionModel collection) async {
    await StorageManager.textCollectionBox.add(collection);
  }

  /// 컬렉션 업데이트
  Future<void> updateCollection(int id, TextCollectionModel updatedCollection) async {
    final box = StorageManager.textCollectionBox;
    final index = box.values.toList().indexWhere((collection) => collection.id == id);
    if (index != -1) {
      await box.putAt(index, updatedCollection);
    }
  }

  /// 컬렉션 삭제
  Future<void> deleteCollection(int id) async {
    final box = StorageManager.textCollectionBox;
    final index = box.values.toList().indexWhere((collection) => collection.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }
}
