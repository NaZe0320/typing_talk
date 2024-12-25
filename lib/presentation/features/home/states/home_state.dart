import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int level,
    @Default(0) int currentXp,
    @Default(999) int nextLevelXp,
    @Default(0) int streakDays,
    @Default(false) bool isPremium,
    @Default(false) bool isLoading,
    String? error,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) => _$HomeStateFromJson(json);
}
