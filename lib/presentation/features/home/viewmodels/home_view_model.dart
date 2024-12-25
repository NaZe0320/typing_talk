import 'package:typing_talk/core/base/base_intent.dart';
import 'package:typing_talk/core/base/base_view_model.dart';
import 'package:typing_talk/presentation/features/home/intents/home_intent.dart';
import 'package:typing_talk/presentation/features/home/states/home_state.dart';

class HomeViewModel extends BaseViewModel<HomeIntent, HomeState> {
  HomeViewModel(super.state);

  @override
  void dispatch(BaseIntent intent) {
    switch (intent) {
      case LoadHomeDataIntent():
      //_handleLoadHomeData();

      case StartQuickPracticeIntent():
      //_handleStartQuickPractice();

      case NavigateToPracticeIntent():
      //_handleNavigateToPractice();
    }
  }
}
