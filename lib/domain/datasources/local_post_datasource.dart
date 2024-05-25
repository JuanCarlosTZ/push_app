import 'package:push_app/domain/entities/post.dart';

abstract class LocalPostDatasource {
  Future<List<Post>> getPosts({int limit = 10, int offset = 0});
  Future<int?> savePost(Post post);
  Future<bool> removePost(Post post);
}
