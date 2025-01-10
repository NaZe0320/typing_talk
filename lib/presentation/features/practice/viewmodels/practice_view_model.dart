import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/data/repositories/practice_sentence_repository_impl.dart';
import 'dart:async';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/domain/repositories/practice_sentence_repository.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_setting_view_model.dart';

part 'practice_view_model.g.dart';

@riverpod
class PracticeViewModel extends _$PracticeViewModel {
  late final PracticeSentenceRepository _repository;
  Timer? _practiceTimer;
  DateTime? _startTime;
  static const int testModeDuration = 300;

  PracticeViewModel() {
    _repository = PracticeSentenceRepositoryImpl();
  }

  @override
  PracticeState build() {
    final settingState = ref.watch(practiceSettingViewModelProvider);

    ref.onDispose(() {
      _practiceTimer?.cancel();
    });

    final fetchedSentences = _getSentences();

    return PracticeState(
      allMessages: fetchedSentences,
      displayedMessages: [
        TypingMessage(
          content: fetchedSentences[0],
          type: SentenceType.prompt,
          status: SentenceStatus.current,
        )
      ],
      practiceMode: settingState.practiceMode, // Set practice mode from settings
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
        if (state.practiceMode == PracticeMode.practice) {
          // Practice 모드: 시간 증가
          final elapsed = DateTime.now().difference(_startTime!).inSeconds;
          state = state.copyWith(elapsedSeconds: elapsed);
        } else {
          // Test 모드: 시간 감소 효과를 위해 elapsedSeconds를 증가시키되,
          // 남은 시간이 0이 되면 타이머 종료
          final elapsed = DateTime.now().difference(_startTime!).inSeconds;
          if (elapsed >= testModeDuration) {
            timer.cancel();
            state = state.copyWith(
              elapsedSeconds: testModeDuration,
              isComplete: true,
            );
          } else {
            state = state.copyWith(elapsedSeconds: elapsed);
          }
        }
      }
    });
  }

  // 타수(분당) 계산 메서드 추가
  double getTypingSpeed() {
    if (state.elapsedSeconds == 0) return 0;
    return (state.totalKeystrokes * 60) / state.elapsedSeconds;
  }

  // 정확도 계산 메서드 추가
  double getAccuracy() {
    if (state.totalKeystrokes == 0) return 0;
    return (state.correctKeystrokes / state.totalKeystrokes) * 100;
  }

  void handleSubmit() {
    if (state.currentInput.trim().isEmpty) return;

    final currentIndex = state.allMessages.indexWhere(
        (message) => message == state.displayedMessages.firstWhere((m) => m.status == SentenceStatus.current).content);

    List<TypingMessage> updatedMessages = state.displayedMessages.map((message) {
      if (message.status == SentenceStatus.current) {
        return message.copyWith(status: SentenceStatus.completed);
      }
      return message;
    }).toList();

    updatedMessages.add(TypingMessage(
      content: state.currentInput,
      type: SentenceType.submitted,
      status: SentenceStatus.completed,
    ));

    if (currentIndex < state.allMessages.length - 1) {
      updatedMessages.add(TypingMessage(
        content: state.allMessages[currentIndex + 1],
        type: SentenceType.prompt,
        status: SentenceStatus.current,
      ));
    } else {
      state = state.copyWith(isComplete: true); //완료 상태
    }

    state = state.copyWith(
      displayedMessages: updatedMessages,
      currentMessageIndex: currentIndex + 1,
      currentInput: '',
    );
  }

  void onTextInput(String value) {
    final targetMessage = state.allMessages[state.currentMessageIndex];
    final updatedStates = _updateCharacterStates(
      value,
      targetMessage,
      state.characterStates,
    );

    state = state.copyWith(
      currentInput: value,
      characterStates: updatedStates,
    );
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
