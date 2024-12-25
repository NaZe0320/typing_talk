//홈 화면 관련 모든 사용자 의도 정의
import 'package:typing_talk/core/base/base_intent.dart';

sealed class HomeIntent extends BaseIntent {
  const HomeIntent();
}

final class LoadHomeDataIntent extends HomeIntent {
  const LoadHomeDataIntent();
}

final class StartQuickPracticeIntent extends HomeIntent {
  const StartQuickPracticeIntent();
}

final class NavigateToPracticeIntent extends HomeIntent {
  const NavigateToPracticeIntent();
}
