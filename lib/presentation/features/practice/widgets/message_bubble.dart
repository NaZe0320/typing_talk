import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final TypingMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceState = ref.watch(practiceViewModelProvider);

    return Row(
      mainAxisAlignment: message.type == SentenceType.prompt ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 320),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: message.type == SentenceType.prompt
                ? message.status == SentenceStatus.current
                    ? AppColors.secondaryBlue
                    : Colors.grey.shade50
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: message.status == SentenceStatus.current ? Border.all(color: AppColors.primaryBlue) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.type == SentenceType.prompt
                  ? _buildTargetMessage(message, practiceState.characterStates)
                  : _buildUserMessage(message),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTargetMessage(TypingMessage message, List<CharacterState> states) {
    return RichText(
      text: TextSpan(
        children: List.generate(message.content.length, (index) {
          final char = message.content[index];
          final state = message.status == SentenceStatus.current && index < states.length
              ? states[index]
              : CharacterState.waiting;
          return TextSpan(
            text: char,
            style: AppTypography.b2_4.copyWith(
              color: message.status == SentenceStatus.current ? state.color : AppColors.gray500,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserMessage(TypingMessage message) {
    return Text(
      message.content,
      style: AppTypography.b2_4.copyWith(
        color: AppColors.primaryText,
      ),
    );
  }
}
