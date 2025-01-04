// lib/presentation/features/practice/viewmodels/practice_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_state.dart';

part 'practice_view_model.g.dart';

@riverpod
class PracticeViewModel extends _$PracticeViewModel {
  Timer? _timer;
  Timer? _wpmTimer;
  DateTime? _startTime;
  int _totalCharacters = 0;

  @override
  PracticeState build() {
    return const PracticeState();
  }

  void initialize({
    required List<String> sentences,
    required bool showRealTimeFeedback,
    Duration? timeLimit, // null이면 타자연습 모드
  }) {
    final messages = sentences
        .map((content) => TypingMessage(
              id: DateTime.now().toString(),
              content: content,
              isTarget: true,
            ))
        .toList();

    state = state.copyWith(
      messages: messages,
      showRealTimeFeedback: showRealTimeFeedback,
      remainingTime: timeLimit,
    );

    if (timeLimit != null) {
      _startTimer();
    }

    _startTime = DateTime.now();
    _startWpmCalculation();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime == null || state.remainingTime!.inSeconds <= 0) {
        timer.cancel();
        _completeTest();
      } else {
        state = state.copyWith(
          remainingTime: state.remainingTime! - const Duration(seconds: 1),
        );
      }
    });
  }

  void _startWpmCalculation() {
    _wpmTimer?.cancel();
    _wpmTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        final duration = DateTime.now().difference(_startTime!);
        final minutes = duration.inMinutes > 0 ? duration.inMinutes : 1;
        final wpm = (_totalCharacters / 5) ~/ minutes; // 5는 평균 단어 길이
        state = state.copyWith(currentWPM: wpm);
      }
    });
  }

  void updateCurrentInput(String input) {
    state = state.copyWith(currentInput: input);

    if (state.showRealTimeFeedback) {
      _checkAccuracy(input);
    }
  }

  void submitInput() {
    if (state.currentInput == null || state.currentInput!.isEmpty) return;

    final currentMessage = state.messages[state.currentMessageIndex];
    final input = state.currentInput!;

    _totalCharacters += input.length;

    final accuracy = _calculateAccuracy(currentMessage.content, input);
    final updatedMessage = currentMessage.copyWith(
      userInput: input,
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final updatedMessages = List<TypingMessage>.from(state.messages);
    updatedMessages[state.currentMessageIndex] = updatedMessage;

    state = state.copyWith(
      messages: updatedMessages,
      currentInput: '',
      currentMessageIndex: state.currentMessageIndex + 1,
      accuracy: (state.accuracy + accuracy) / 2, // 평균 정확도 계산
    );

    if (state.currentMessageIndex >= state.messages.length) {
      _completeTest();
    }
  }

  void _checkAccuracy(String input) {
    if (state.currentMessageIndex >= state.messages.length) return;

    final targetMessage = state.messages[state.currentMessageIndex];
    final accuracy = _calculateAccuracy(targetMessage.content, input);
    state = state.copyWith(accuracy: accuracy);
  }

  double _calculateAccuracy(String target, String input) {
    if (input.isEmpty) return 0.0;
    if (input.length > target.length) return 0.0;

    int correctChars = 0;
    for (int i = 0; i < input.length; i++) {
      if (i < target.length && input[i] == target[i]) {
        correctChars++;
      }
    }

    return (correctChars / target.length) * 100;
  }

  void _completeTest() {
    state = state.copyWith(isCompleted: true);
    _timer?.cancel();
    _wpmTimer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
    _wpmTimer?.cancel();
  }
}
