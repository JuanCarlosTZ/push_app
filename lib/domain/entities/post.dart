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
    this.isarId,
    required this.postId,
    required this.title,
    required this.caption,
    required this.urlImage,
    required this.type,
    required this.author,
    required this.published,
  });

  Post copyWith({
    Id? isarId,
    String? postId,
    String? title,
    String? caption,
    String? urlImage,
    String? type,
    String? author,
    DateTime? published,
  }) {
    return Post(
      isarId: isarId ?? this.isarId,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      urlImage: urlImage ?? this.urlImage,
      type: type ?? this.type,
      author: author ?? this.author,
      published: published ?? this.published,
    );
  }
}
