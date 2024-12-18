//StateNotifier를 확장한 기본 ViewModel
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/base/base_intent.dart';

abstract class BaseViewModel<I extends BaseIntent, S> extends StateNotifier<S> {
  BaseViewModel(S state) : super(state);

  void dispatch(I intent);
}
