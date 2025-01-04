import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:typing_talk/core/base/base_screen.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/domain/entities/typing_message.dart';
import 'package:typing_talk/presentation/common/widgets/default_app_bar.dart';
import 'package:typing_talk/presentation/features/practice/viewmodels/practice_view_model.dart';

class PracticeScreen extends BaseScreen {
  const PracticeScreen({super.key});

  @override
  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return const DefaultAppBar('타자 연습');
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
                '${state.currentMessageIndex}/${state.messages.length}',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              final isCurrentMessage = index == state.currentMessageIndex;
              return _buildMessageBubble(
                message: message,
                isCurrentMessage: isCurrentMessage,
                showFeedback: state.showRealTimeFeedback,
              );
            },
          ),
        ),
        if (!state.isCompleted)
          Container(
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
                    onChanged: viewModel.updateCurrentInput,
                    onSubmitted: (_) => viewModel.submitInput(),
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
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: viewModel.submitInput,
                  child: const Icon(Icons.send, color: AppColors.primaryBlue),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMessageBubble({
    required TypingMessage message,
    required bool isCurrentMessage,
    required bool showFeedback,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isTarget ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: message.isTarget
                  ? (isCurrentMessage ? AppColors.secondaryBlue : AppColors.surface)
                  : AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(16),
              border: isCurrentMessage && message.isTarget ? Border.all(color: AppColors.primaryBlue) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isTarget ? message.content : message.userInput!,
                  style: AppTypography.b2_4.copyWith(
                    color: message.isTarget ? AppColors.primaryText : AppColors.white,
                  ),
                ),
                if (message.isCompleted && showFeedback) ...[
                  const SizedBox(height: 4),
                  Text(
                    '정확도: 98%', // 실제 계산된 정확도로 대체 필요
                    style: AppTypography.cap_4.copyWith(
                      color: message.isTarget ? AppColors.secondaryText : AppColors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
