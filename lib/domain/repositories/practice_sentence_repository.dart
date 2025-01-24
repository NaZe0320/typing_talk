import 'package:typing_talk/data/models/text_collection_model.dart';
import 'package:typing_talk/domain/entities/text_item.dart';

abstract class PracticeSentenceRepository {
  List<String> getSentencesByTextId(int textId);
  // List<TextItem> getAllTexts();
  // Future<void> addTextCollection(TextCollection collection);
  // Future<void> deleteTextCollection(int id);
}
