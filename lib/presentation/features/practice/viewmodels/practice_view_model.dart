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
  int _totalKeystrokes = 0;

  PracticeViewModel() {
    _repository = PracticeSentenceRepositoryImpl();
  }

  @override
  PracticeState build() {
    ref.onDispose(() {
      _practiceTimer?.cancel();
    });

    // 설정에서 선택된 문장들을 가져와서 초기 상태 설정
    final sentences = _getSentences();
    return PracticeState(
      messages: sentences.map((content) {
        return TypingMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          characterStates: List.filled(content.length, CharacterState.waiting),
        );
      }).toList(),
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
    _practiceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
        final wpm = _calculateWPM(elapsedSeconds);
        state = state.copyWith(currentWPM: wpm);
      }
    });
  }

  int _calculateWPM(int elapsedSeconds) {
    if (elapsedSeconds == 0) return 0;
    // 한글의 경우 타자수 계산을 위해 음절 단위로 계산
    return (_totalKeystrokes ~/ 5) * 60 ~/ elapsedSeconds;
  }

  void onTextInput(String input) {
    if (state.isCompleted) return;

    final currentMessage = state.messages[state.currentMessageIndex];
    final targetContent = currentMessage.content;

    // 입력된 키스트로크 수 업데이트
    _totalKeystrokes = _calculateTotalKeystrokes();

    // 문자별 상태 업데이트
    final List<CharacterState> newStates = _updateCharacterStates(
      input,
      targetContent,
      currentMessage.characterStates,
    );

    // 현재 메시지 업데이트
    final updatedMessage = currentMessage.copyWith(
      userInput: input,
      characterStates: newStates,
      cursorPosition: input.length,
    );

    final updatedMessages = List<TypingMessage>.from(state.messages);
    updatedMessages[state.currentMessageIndex] = updatedMessage;

    // 문장 완료 체크 및 상태 업데이트
    if (input == targetContent) {
      _handleCompletedMessage(updatedMessages);
    } else {
      state = state.copyWith(messages: updatedMessages);
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

  void _handleCompletedMessage(List<TypingMessage> messages) {
    // 현재 메시지를 완료 상태로 업데이트
    messages[state.currentMessageIndex] = messages[state.currentMessageIndex].copyWith(isCompleted: true);

    // 다음 메시지가 있으면 이동, 없으면 연습 완료
    if (state.currentMessageIndex < messages.length - 1) {
      state = state.copyWith(
        messages: messages,
        currentMessageIndex: state.currentMessageIndex + 1,
      );
    } else {
      _practiceTimer?.cancel();
      state = state.copyWith(
        messages: messages,
        isCompleted: true,
      );
    }

    _updateStats();
  }

  void _updateStats() {
    // 정확도 계산
    int totalCharacters = 0;
    int correctCharacters = 0;

    for (final message in state.messages) {
      if (!message.isCompleted) continue;

      totalCharacters += message.content.length;
      correctCharacters += message.characterStates.where((state) => state == CharacterState.correct).length;
    }

    final accuracy = totalCharacters > 0 ? (correctCharacters / totalCharacters) * 100 : 0.0;

    state = state.copyWith(accuracy: accuracy);
  }

  int _calculateTotalKeystrokes() {
    int total = 0;
    for (final message in state.messages) {
      if (message.userInput != null) {
        total += message.userInput!.length;
      }
    }
    return total;
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
