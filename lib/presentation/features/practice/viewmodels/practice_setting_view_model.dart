import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typing_talk/data/repositories/text_collection_repository_impl.dart';
import 'package:typing_talk/domain/entities/text_item.dart';
import 'package:typing_talk/domain/enums/practice_mode.dart';
import 'package:typing_talk/presentation/features/practice/states/practice_setting_state.dart';

part 'practice_setting_view_model.g.dart';

@riverpod
class PracticeSettingViewModel extends _$PracticeSettingViewModel {
  late final TextCollectionRepositoryImpl _repository;

  PracticeSettingViewModel() {
    _repository = TextCollectionRepositoryImpl();
  }
  @override
  PracticeSettingState build() {
    _repository.initialize();
    final availableTexts = _repository.getAllCollections();
    print('테스트 : $availableTexts');

    return PracticeSettingState(availableTexts: availableTexts);
  }

  void togglePracticeMode(PracticeMode mode) {
    state = state.copyWith(
      practiceMode: mode,
      timeLimit: mode == PracticeMode.test ? const Duration(minutes: 5) : null,
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

  // Get selected sentences from repository
  List<String> getSelectedSentences() {
    List<String> sentences = [];
    for (var id in state.selectedTexts) {
      sentences.addAll(_repository.getTextCollectionByTextId(id));
    }
    return sentences;
  }
}
