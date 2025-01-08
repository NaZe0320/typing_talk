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
              _buildStatItem(
                '진행률',
                '${state.currentMessageIndex + 1}/${state.allMessages.length}',
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: state.displayedMessages.length,
              itemBuilder: (context, index) {
                final message = state.displayedMessages[index];
                return _buildMessageBubble(
                  message: message,
                );
              },
            ),
          ),
        ),
        _TypingInput(onChanged: viewModel.onTextInput, onSubmit: viewModel.handleSubmit, targetContent: ""),
      ],
    );
  }

  Widget _buildMessageBubble({
    required TypingMessage message,
  }) {
    return Row(
      mainAxisAlignment: message.type == SentenceType.prompt ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 320), //TODO (화면 비율 따라 작성)
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: message.type == SentenceType.prompt
                ? message.status == SentenceStatus.current
                    ? Colors.blue.shade50
                    : Colors.grey.shade50
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: message.status == SentenceStatus.current ? Border.all(color: Colors.blue.shade200) : null,
          ),
          child: Column(
            children: [
              message.type == SentenceType.prompt ? _buildTargetMessage(message) : _buildUserMessage(message),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTargetMessage(TypingMessage message) {
    return RichText(
      text: TextSpan(
        children: List.generate(message.content.length, (index) {
          final char = message.content[index];
          return TextSpan(
            text: char,
            style: AppTypography.b2_4.copyWith(
              color: AppColors.primaryText,
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
    required this.onSubmit,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
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
              onSubmitted: (_) {
                widget.onSubmit();
                _controller.clear();
              },
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
              widget.onSubmit();
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
