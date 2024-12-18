//홈 화면 관련 모든 사용자 의도 정의
import 'package:typing_talk/core/base/base_intent.dart';
import 'package:typing_talk/presentation/features/home/enums/practice_type.dart';

sealed class HomeIntent extends BaseIntent {
  HomeIntent();
}

class LoadHomeDataIntent extends HomeIntent {
  LoadHomeDataIntent();
}

class StartPracticeIntent extends HomeIntent {
  final PracticeType type;
  StartPracticeIntent(this.type);
}

class ViewStatsIntent extends HomeIntent {
  ViewStatsIntent();
}

class UpdateDailyChallengeIntent extends HomeIntent {
  final int progress;
  UpdateDailyChallengeIntent(this.progress);
}
