import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/domain/entities/text_item.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_setting_state.dart';

part 'practice_setting_view_model.g.dart';

@riverpod
class PracticeSettingViewModel extends _$PracticeSettingViewModel {
  PracticeSettingViewModel(); // 기본 생성자 추가

  @override
  PracticeSettingState build() {
    final texts = [
      const TextItem(id: 10, title: "일상 대화 모음", difficulty: "쉬움", length: "짧음"),
      const TextItem(id: 223, title: "비즈니스 이메일", difficulty: "중간", length: "중간"),
      const TextItem(id: 32, title: "IT 용어 모음", difficulty: "어려움", length: "중간"),
      const TextItem(id: 45, title: "문학 작품 발췌", difficulty: "중간", length: "긺"),
      const TextItem(id: 57, title: "뉴스 기사", difficulty: "중간", length: "중간"),
    ];

    return PracticeSettingState(availableTexts: texts);
  }

  void togglePracticeMode(String mode) {
    state = state.copyWith(
      practiceMode: mode,
      timeLimit: mode == 'test' ? const Duration(minutes: 5) : null,
    );
    _updateStartButtonState();
  }

  void toggleTextSelection(int id) {
    final currentSelection = List<int>.from(state.selectedTexts);
    if (currentSelection.contains(id)) {
      currentSelection.remove(id);
    } else {
      currentSelection.add(id);
    }
    state = state.copyWith(selectedTexts: currentSelection);
    _updateStartButtonState();
  }

  void _updateStartButtonState() {
    state = state.copyWith(
      isStartButtonEnabled: state.selectedTexts.isNotEmpty,
    );
  }

  // 선택된 문장들 가져오기
  List<String> getSelectedSentences() {
    return state.availableTexts.where((text) => state.selectedTexts.contains(text.id)).map((e) => e.title).toList();
  }
}
