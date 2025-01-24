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
            difficulty: "쉬움",
            length: "짧음",
          ),
          TextCollectionModel(
            id: 2,
            title: "비즈니스 이메일",
            sentences: [
              "검토하신 내용에 대해 회신 드립니다.",
              "요청하신 자료를 첨부하여 보내드립니다.",
              "다음 주 회의 일정을 조율하고자 합니다.",
              "프로젝트 진행 상황을 공유드립니다.",
            ],
            difficulty: "중간",
            length: "중간",
          ),
          TextCollectionModel(
            id: 3,
            title: "IT 용어",
            sentences: [
              "클라우드 컴퓨팅은 인터넷을 통해 컴퓨팅 리소스를 제공합니다.",
              "API는 응용 프로그램 프로그래밍 인터페이스의 약자입니다.",
              "버전 관리 시스템은 소스 코드의 변경사항을 추적합니다.",
              "데이터베이스는 구조화된 정보를 저장하고 관리합니다.",
            ],
            difficulty: "어려움",
            length: "긺",
          ),
          TextCollectionModel(
            id: 4,
            title: "문학 작품",
            sentences: [
              "나의 살던 고향은 꽃피는 산골이었습니다.",
              "떠나온 이길을 되돌아보니 이미 날은 저물어 있었다.",
              "청산도 절로 절로 녹수도 절로 절로",
              "가을 하늘 공활한데 높고 구름 없다",
            ],
            difficulty: "중간",
            length: "중간",
          ),
          TextCollectionModel(
            id: 5,
            title: "뉴스 기사",
            sentences: [
              "정부는 오늘 새로운 정책을 발표했다고 밝혔다.",
              "전문가들은 이번 조치가 긍정적인 영향을 미칠 것으로 전망했다.",
              "시민들의 다양한 의견을 수렴하여 최종안을 마련할 예정이다.",
              "관계자는 구체적인 시행 방안을 검토 중이라고 설명했다.",
            ],
            difficulty: "중간",
            length: "긺",
          ),
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
