import 'package:typing_talk/domain/repositories/practice_sentence_repository.dart';

class PracticeSentenceRepositoryImpl implements PracticeSentenceRepository {
  static const String _textCollectionsKey = 'text_collections';

  // 실제로는 DB나 API에서 가져올 데이터
  final Map<int, List<String>> _sentencesMap = {
    10: [
      // 일상 대화 모음
      "안녕하세요, 오늘 날씨가 참 좋네요.",
      "주말에는 주로 어떤 것을 하면서 시간을 보내시나요?",
      "이번 주말에 영화 보러 가실래요?",
      "커피 한잔 마시면서 이야기 나눠요.",
    ],
    223: [
      // 비즈니스 이메일
      "검토하신 내용에 대해 회신 드립니다.",
      "요청하신 자료를 첨부하여 보내드립니다.",
      "다음 주 회의 일정을 조율하고자 합니다.",
      "프로젝트 진행 상황을 공유드립니다.",
    ],
    32: [
      // IT 용어 모음
      "클라우드 컴퓨팅은 인터넷을 통해 컴퓨팅 리소스를 제공합니다.",
      "API는 응용 프로그램 프로그래밍 인터페이스의 약자입니다.",
      "버전 관리 시스템은 소스 코드의 변경사항을 추적합니다.",
      "데이터베이스는 구조화된 정보를 저장하고 관리합니다.",
    ],
    45: [
      // 문학 작품 발췌
      "나의 살던 고향은 꽃피는 산골이었습니다.",
      "떠나온 이길을 되돌아보니 이미 날은 저물어 있었다.",
      "청산도 절로 절로 녹수도 절로 절로",
      "가을 하늘 공활한데 높고 구름 없다",
    ],
    57: [
      // 뉴스 기사
      "정부는 오늘 새로운 정책을 발표했다고 밝혔다.",
      "전문가들은 이번 조치가 긍정적인 영향을 미칠 것으로 전망했다.",
      "시민들의 다양한 의견을 수렴하여 최종안을 마련할 예정이다.",
      "관계자는 구체적인 시행 방안을 검토 중이라고 설명했다.",
    ],
  };

  @override
  List<String> getSentencesByTextId(int textId) {
    return _sentencesMap[textId] ?? [];
  }
}
