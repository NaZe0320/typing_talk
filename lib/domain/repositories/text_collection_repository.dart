import 'package:typing_talk/data/models/text_collection_model.dart';
import 'package:typing_talk/domain/entities/text_item.dart';

abstract class TextCollectionRepository {
  List<String> getTextCollectionByTextId(int textId);
}
