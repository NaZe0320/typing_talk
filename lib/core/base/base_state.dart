//모든 상태의 기본이 되는 추상 클래스
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

@freezed
abstract class BaseState with _$BaseState {
  const factory BaseState.initial() = Initial;
  const factory BaseState.loading() = Loading;
  const factory BaseState.error(String message) = Error;
}
