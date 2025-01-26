//문자별 상태 추적 기능
import 'dart:ui';

import 'package:typing_talk/core/theme/app_colors.dart';

enum CharacterState {
  waiting, // 입력 전
  typing, // 입력 중 (한글 조합 중)
  correct, // 입력 완료 & 일치
  incorrect; // 입력 완료 & 불일치

  Color get color {
    return switch (this) {
      CharacterState.waiting => AppColors.gray400,
      CharacterState.typing => const Color(0xFFFFB800), // 노란색
      CharacterState.correct => AppColors.successText,
      CharacterState.incorrect => AppColors.errorText,
    };
  }
}
