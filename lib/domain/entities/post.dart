import 'package:isar/isar.dart';

part 'post.g.dart';

@collection
class Post {
  Id? isarId;
  final String postId;
  final String title;
  final String? caption;
  final String urlImage;
  final String? type;
  final String author;
  final DateTime published;

  Post({
    required this.postId,
    required this.title,
    required this.caption,
    required this.urlImage,
    required this.type,
    required this.author,
    required this.published,
  });
}
