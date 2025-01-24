import 'package:hive_flutter/hive_flutter.dart';

part 'text_collection_model.g.dart';

@HiveType(typeId: 0)
class TextCollectionModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> sentences;

  @HiveField(3)
  final String description;

  TextCollectionModel({
    required this.id,
    required this.title,
    required this.sentences,
    required this.description,
  });
}
