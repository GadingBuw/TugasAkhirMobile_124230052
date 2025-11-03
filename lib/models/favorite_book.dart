import 'package:hive/hive.dart';

part 'favorite_book.g.dart';

@HiveType(typeId: 0)
class FavoriteBook extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String imageUrl;

  FavoriteBook({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}