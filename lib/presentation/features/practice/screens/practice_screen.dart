import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/domain/enums/character_state.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    return DefaultAppBar(state.practiceMode == PracticeMode.practice ? '타자연습' : '타자검정');
  }

  @override
  Future<(bool, String?)> onWillPop(BuildContext context) async {
    context.go('/');
    return (false, null);
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceViewModelProvider);
    final viewModel = ref.read(practiceViewModelProvider.notifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            border: Border(
              top: BorderSide(color: AppColors.defaultBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('현재 타수', '${state.currentWPM}'),
              _buildStatItem('정확도', '${state.accuracy.toStringAsFixed(1)}%'),
              _buildStatItem(
                '진행률',
                '${state.currentMessageIndex + 1}/${state.allMessages.length}',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            reverse: true,
            itemCount: state.allMessages.length,
            itemBuilder: (context, index) {
              final message = state.allMessages[index];
              final isCurrentMessage = index == state.currentMessageIndex;
              return _buildMessageBubble(
                message: message,
                isCurrentMessage: isCurrentMessage,
              );
            },
          ),
        ),
        if (!state.isCompleted)
          _TypingInput(
            onChanged: viewModel.onTextInput,
            targetContent: state.allMessages[state.currentMessageIndex].content,
          ),
      ],
    );
  }

  Widget _buildMessageBubble({
    required TypingMessage message,
    required bool isCurrentMessage,
  }) {
    final isTargetMessage = message.userInput == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isTargetMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isTargetMessage
                  ? (isCurrentMessage ? AppColors.secondaryBlue : AppColors.surface)
                  : AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(16),
              border: isCurrentMessage && isTargetMessage ? Border.all(color: AppColors.primaryBlue) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTargetMessage) _buildTargetMessage(message, isCurrentMessage) else _buildUserMessage(message),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMessage(TypingMessage message, bool isCurrentMessage) {
    return RichText(
      text: TextSpan(
        children: List.generate(message.content.length, (index) {
          final char = message.content[index];
          return TextSpan(
            text: char,
            style: AppTypography.b2_4.copyWith(
              color: isCurrentMessage ? message.characterStates[index].color : AppColors.primaryText,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserMessage(TypingMessage message) {
    return Text(
      message.userInput!,
      style: AppTypography.b2_4.copyWith(
        color: AppColors.white,
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.cap_4.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.b2_6.copyWith(
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}

class _TypingInput extends StatefulWidget {
  const _TypingInput({
    required this.onChanged,
    required this.targetContent,
  });

  final ValueChanged<String> onChanged;
  final String targetContent;

  @override
  State<_TypingInput> createState() => _TypingInputState();
}

class _TypingInputState extends State<_TypingInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    widget.onChanged(_controller.text);
    // 입력이 완료되면 TextField를 초기화
    if (_controller.text == widget.targetContent) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray700.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              onSubmitted: (_) => _handleTextChange(),
              decoration: InputDecoration(
                hintText: '문장을 입력하세요',
                hintStyle: AppTypography.b2_4.copyWith(
                  color: AppColors.gray400,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryBlue),
            onPressed: () {
              _handleTextChange();
            },
          ),
        ],
      ),
    );
  }
}
