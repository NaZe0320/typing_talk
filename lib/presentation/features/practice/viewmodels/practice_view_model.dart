import 'dart:math';

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
      getTypingSpeed(); //시간이 지날때, 타수 계산 메서드 실행
    });
  }

  // 타수(분당) 계산 메서드 추가
  double getTypingSpeed() {
    if (state.elapsedSeconds == 0) return 0;
    return ((state.totalKeystrokes + state.currentKeystrokes) * 60) / state.elapsedSeconds;
  }

  // 정확도 계산 메서드 추가
  double getAccuracy() {
    if (state.totalKeystrokes + state.currentKeystrokes == 0) return 0;
    return ((state.totalCorrectKeystrokes + state.currentCorrectKeystrokes) /
            (state.totalKeystrokes + state.currentKeystrokes)) *
        100;
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
      _practiceTimer?.cancel();
    }

    final totalKeystrokes = state.totalKeystrokes + state.currentKeystrokes;
    final totalCorrectKeystrokes = state.totalCorrectKeystrokes + state.currentCorrectKeystrokes;

    state = state.copyWith(
      displayedMessages: updatedMessages,
      currentMessageIndex: currentIndex + 1,
      totalKeystrokes: totalKeystrokes,
      totalCorrectKeystrokes: totalCorrectKeystrokes,
      currentKeystrokes: 0,
      currentCorrectKeystrokes: 0,
      currentInput: '',
    );
  }

  void onTextInput(String value, int cursorPosition) {
    final targetMessage = state.allMessages[state.currentMessageIndex];
    final updatedStates = _updateCharacterStates(
      value,
      targetMessage,
      state.characterStates,
      cursorPosition, // 커서 위치 전달
    );

    final currentJamoCount = _countJamo(value);

    // 일치하는 자모 수 계산 (CharacterState 고려)
    final correctJamoCount = _countMatchingJamo(value, targetMessage, updatedStates);

    state = state.copyWith(
      currentInput: value,
      characterStates: updatedStates,
      currentKeystrokes: currentJamoCount,
      currentCorrectKeystrokes: correctJamoCount,
    );
  }

  // 두 문자열 간의 일치하는 자모 수를 계산
  int _countMatchingJamo(String input, String target, List<CharacterState> states) {
    int matchCount = 0;

    // 각 글자별로 상태 확인
    for (int i = 0; i < min(input.length, target.length); i++) {
      // correct 상태인 경우만 해당 글자의 자모 수를 카운트
      if (states[i] == CharacterState.correct ||
          states[i] == CharacterState.typing ||
          states[i] == CharacterState.incorrect) {
        List<String> currentInputJamo = _decompose(input[i]);
        List<String> currentTargetJamo = _decompose(target[i]);

        // 분해된 자모들을 비교하여 일치하는 개수 세기
        int minJamoLength = min(currentInputJamo.length, currentTargetJamo.length);
        for (int j = 0; j < minJamoLength; j++) {
          if (currentInputJamo[j] == currentTargetJamo[j]) {
            matchCount++;
          }
        }
      }
    }
    return matchCount;
  }

  List<CharacterState> _updateCharacterStates(
    String input,
    String target,
    List<CharacterState> currentStates,
    int cursorPosition,
  ) {
    final List<CharacterState> newStates = List.filled(target.length, CharacterState.waiting);

    for (int i = 0; i < target.length; i++) {
      if (i >= input.length) {
        newStates[i] = CharacterState.waiting;
        continue;
      }

      if (_isKorean(target[i])) {
        // 현재 입력 중인 위치
        if (i == cursorPosition - 1) {
          // 목표 글자가 받침이 있는 경우
          if (_hasJongseong(target[i])) {
            // 현재 입력이 완성된 글자인 경우
            if (_isCompletedSyllable(input[i])) {
              if (input[i] == target[i]) {
                // 완전히 일치하면 correct
                newStates[i] = CharacterState.correct;
              } else {
                // 초성+중성만 일치하면 typing
                newStates[i] = CharacterState.typing;
              }
            } else {
              // 미완성 상태면 typing
              newStates[i] = CharacterState.typing;
            }
          } else {
            // 받침이 없는 글자는 기존 로직대로 처리
            if (!_isCompletedSyllable(input[i])) {
              newStates[i] = CharacterState.typing;
            } else {
              newStates[i] = input[i] == target[i] ? CharacterState.correct : CharacterState.incorrect;
            }
          }
        } else {
          // 입력이 완료된 위치
          newStates[i] = input[i] == target[i] ? CharacterState.correct : CharacterState.incorrect;
        }
      } else {
        newStates[i] = input[i] == target[i] ? CharacterState.correct : CharacterState.incorrect;
      }
    }

    return newStates;
  }

  // 글자가 받침을 가지고 있는지 확인
  bool _hasJongseong(String char) {
    if (!_isKorean(char)) return false;
    final code = char.codeUnitAt(0) - 0xAC00;
    final jong = code % 28;
    return jong > 0;
  }

  // 문자열의 총 자모 수를 계산
  List<String> _decompose(String text) {
    List<String> result = [];

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (_isKorean(char)) {
        final code = char.codeUnitAt(0) - 0xAC00;

        // 초성, 중성, 종성 분리
        final jong = code % 28;
        final jung = ((code - jong) / 28 % 21).floor();
        final cho = ((code - jong) / 28 / 21).floor();

        // 초성 추가
        result.add(String.fromCharCode(0x1100 + cho));
        // 중성 추가
        result.add(String.fromCharCode(0x1161 + jung));
        // 종성이 있는 경우에만 추가
        if (jong > 0) {
          result.add(String.fromCharCode(0x11A7 + jong));
        }
      } else if (_isCompatibilityJamo(char)) {
        // 호환용 자모를 조합형 자모로 변환
        result.add(_convertToConjoiningJamo(char));
      } else {
        result.add(char);
      }
    }

    return result;
  }

  // 호환용 자모인지 확인
  bool _isCompatibilityJamo(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 0x3131 && code <= 0x318E); // 호환용 자모 범위
  }

  // 문자열의 총 자모 수를 계산
  int _countJamo(String text) {
    return _decompose(text).length;
  }

  bool _isKorean(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3; // 완성형 한글 범위
  }

  bool _isCompletedSyllable(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3; // 완성형 한글인 경우만 true
  }

  // 한글 자모 변환을 위한 매핑
  final Map<String, String> _compatibilityToConjoiningJamo = {
    'ㄱ': 'ᄀ',
    'ㄲ': 'ᄁ',
    'ㄴ': 'ᄂ',
    'ㄷ': 'ᄃ',
    'ㄸ': 'ᄄ',
    'ㄹ': 'ᄅ',
    'ㅁ': 'ᄆ',
    'ㅂ': 'ᄇ',
    'ㅃ': 'ᄈ',
    'ㅅ': 'ᄉ',
    'ㅆ': 'ᄊ',
    'ㅇ': 'ᄋ',
    'ㅈ': 'ᄌ',
    'ㅉ': 'ᄍ',
    'ㅊ': 'ᄎ',
    'ㅋ': 'ᄏ',
    'ㅌ': 'ᄐ',
    'ㅍ': 'ᄑ',
    'ㅎ': 'ᄒ',
    'ㅏ': 'ᅡ',
    'ㅐ': 'ᅢ',
    'ㅑ': 'ᅣ',
    'ㅒ': 'ᅤ',
    'ㅓ': 'ᅥ',
    'ㅔ': 'ᅦ',
    'ㅕ': 'ᅧ',
    'ㅖ': 'ᅨ',
    'ㅗ': 'ᅩ',
    'ㅘ': 'ᅪ',
    'ㅙ': 'ᅫ',
    'ㅚ': 'ᅬ',
    'ㅛ': 'ᅭ',
    'ㅜ': 'ᅮ',
    'ㅝ': 'ᅯ',
    'ㅞ': 'ᅰ',
    'ㅟ': 'ᅱ',
    'ㅠ': 'ᅲ',
    'ㅡ': 'ᅳ',
    'ㅢ': 'ᅴ',
    'ㅣ': 'ᅵ'
  };

// 한글 호환 자모를 조합형 자모로 변환
  String _convertToConjoiningJamo(String char) {
    return _compatibilityToConjoiningJamo[char] ?? char;
  }
}
