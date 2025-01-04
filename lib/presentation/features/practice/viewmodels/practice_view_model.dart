// lib/presentation/features/practice/viewmodels/practice_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/data/repositories/practice_sentence_repository_impl.dart';
import 'dart:async';

import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/repositories/practice_sentence_repository.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_setting_view_model.dart';

part 'practice_view_model.g.dart';

@riverpod
class PracticeViewModel extends _$PracticeViewModel {
  late final PracticeSentenceRepository _repository;
  PracticeViewModel() {
    _repository = PracticeSentenceRepositoryImpl();
  }

  @override
  PracticeState build() {
    // 설정 상태를 practice_setting_view_model에서 가져오기
    final settingState = ref.watch(practiceSettingViewModelProvider);
    final allSentences =
        settingState.selectedTexts.expand((textId) => _repository.getSentencesByTextId(textId)).toList();
    return PracticeState(
      timeLimit: settingState.timeLimit,
      practiceMode: settingState.practiceMode,
      messages: allSentences
          .map((content) => TypingMessage(
                id: DateTime.now().toString(),
                content: content,
                isTarget: true,
              ))
          .toList(),
    );
  }
}
