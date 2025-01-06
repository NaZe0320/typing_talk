// lib/presentation/features/practice/viewmodels/practice_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/data/repositories/practice_sentence_repository_impl.dart';
import 'dart:async';

import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/domain/repositories/practice_sentence_repository.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_setting_view_model.dart';

part 'practice_view_model.g.dart';

@riverpod
class PracticeViewModel extends _$PracticeViewModel {
  late final PracticeSentenceRepository _repository;
  Timer? _practiceTimer;
  DateTime? _startTime;

  PracticeViewModel() {
    _repository = PracticeSentenceRepositoryImpl();
  }

  @override
  PracticeState build() {
    ref.onDispose(() {
      _practiceTimer?.cancel();
    });
    final allMessages = _getSentences()
        .map((content) => TypingMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: content,
              characterStates: List.filled(content.length, CharacterState.waiting),
            ))
        .toList();

    return PracticeState(
      allMessages: allMessages,
      visibleMessages: [allMessages.first],
    );
  }

  List<String> _getSentences() {
    final settingState = ref.watch(practiceSettingViewModelProvider);
    final allSentences =
        settingState.selectedTexts.expand((textId) => _repository.getSentencesByTextId(textId)).toList();

    return allSentences;
  }

  void startPractice() {
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _practiceTimer?.cancel();
    _practiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  void onTextInput(String input) {
    if (state.isCompleted) return;

    final currentMessage = state.visibleMessages[state.currentMessageIndex];
    final targetContent = currentMessage.content;

    // 문자별 상태 업데이트 로직...
    final List<CharacterState> newStates = _updateCharacterStates(
      input,
      targetContent,
      currentMessage.characterStates,
    );

    // 현재 메시지 업데이트
    final updatedMessage = currentMessage.copyWith(
      userInput: input,
      characterStates: newStates,
    );

    // 현재 표시된 메시지들 업데이트
    final updatedVisibleMessages = List<TypingMessage>.from(state.visibleMessages);
    updatedVisibleMessages[state.currentMessageIndex] = updatedMessage;

    // 문장 완료 체크
    if (input == targetContent) {
      // 현재 메시지를 완료 상태로 변경
      final completedMessage = updatedMessage.copyWith(isCompleted: true);
      updatedVisibleMessages[state.currentMessageIndex] = completedMessage;

      // 다음 메시지가 있으면 추가
      final nextIndex = state.allMessages.indexOf(currentMessage) + 1;
      if (nextIndex < state.allMessages.length) {
        updatedVisibleMessages.add(state.allMessages[nextIndex]);
      }

      state = state.copyWith(
        visibleMessages: updatedVisibleMessages,
        currentMessageIndex: state.currentMessageIndex + 1,
        isCompleted: nextIndex >= state.allMessages.length,
      );
    } else {
      state = state.copyWith(
        visibleMessages: updatedVisibleMessages,
      );
    }
  }

  List<CharacterState> _updateCharacterStates(
    String input,
    String target,
    List<CharacterState> currentStates,
  ) {
    final List<CharacterState> newStates = List.filled(target.length, CharacterState.waiting);

    for (int i = 0; i < input.length && i < target.length; i++) {
      if (_isKorean(target[i])) {
        if (i >= input.length) {
          newStates[i] = CharacterState.waiting;
        } else if (_isCompletedSyllable(input[i])) {
          newStates[i] = input[i] == target[i] ? CharacterState.correct : CharacterState.incorrect;
        } else {
          newStates[i] = CharacterState.typing;
        }
      } else {
        newStates[i] = input[i] == target[i] ? CharacterState.correct : CharacterState.incorrect;
      }
    }

    return newStates;
  }

  bool _isKorean(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3; // 완성형 한글 범위
  }

  bool _isCompletedSyllable(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3; // 완성형 한글인 경우만 true
  }
}
