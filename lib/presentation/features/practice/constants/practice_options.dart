import 'package:flutter/material.dart';
import 'package:typing_talk/presentation/features/practice/widgets/select_button.dart';

class PracticeOptions {
  static List<SelectOption> modeOptions = [
    SelectOption(
      id: 'normal',
      text: '일반 모드',
      leadingIcon: Icons.straighten,
    ),
    const SelectOption(
      id: 'ai',
      text: 'AI 모드',
      leadingIcon: Icons.psychology,
      disabled: true,
      isPremium: true,
    ),
  ];

  static const List<SelectOption> timeOptions = [
    SelectOption(
      id: '3min',
      text: '3분',
      leadingIcon: Icons.timer,
    ),
    SelectOption(
      id: '5min',
      text: '5분',
      leadingIcon: Icons.timer,
    ),
    SelectOption(
      id: 'unlimited',
      text: '무제한',
      leadingIcon: Icons.all_inclusive,
      disabled: true,
      isPremium: true,
    ),
  ];

  static const List<SelectOption> topicOptions = [
    SelectOption(
      id: 'daily',
      text: '일상',
      leadingIcon: Icons.home,
    ),
    SelectOption(
      id: 'business',
      text: '비즈니스',
      leadingIcon: Icons.business,
    ),
    SelectOption(
      id: 'it',
      text: 'IT/기술',
      leadingIcon: Icons.computer,
    ),
    SelectOption(
      id: 'custom',
      text: '커스텀',
      leadingIcon: Icons.edit,
      disabled: true,
      isPremium: true,
    ),
  ];
}
