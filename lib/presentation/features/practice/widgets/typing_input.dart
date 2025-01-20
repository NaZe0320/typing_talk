import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class TypingInput extends StatefulWidget {
  const TypingInput({
    super.key,
    required this.onChanged,
    required this.onSubmit,
    this.initialText = '',
  });

  final void Function(String text, int cursorPosition) onChanged;
  final VoidCallback onSubmit;
  final String initialText;

  @override
  State<TypingInput> createState() => _TypingInputState();
}

class _TypingInputState extends State<TypingInput> {
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
    widget.onChanged(
      _controller.text,
      _controller.selection.baseOffset,
    );
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
