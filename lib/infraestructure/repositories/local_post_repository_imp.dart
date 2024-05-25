import 'package:push_app/domain/datasources/local_post_datasource.dart';
import 'package:push_app/domain/entities/post.dart';
import 'package:push_app/domain/repositories/local_post_repository.dart';

class LocalPostRepositoryImp extends LocalPostRepository {
  final LocalPostDatasource _datasource;

  LocalPostRepositoryImp(this._datasource);

  @override
  Future<List<Post>> getPosts({int limit = 10, int offset = 0}) {
    return _datasource.getPosts(limit: limit, offset: offset);
  }

  @override
  Future<bool> removePost(Post post) {
    return _datasource.removePost(post);
  }

  @override
  Future<int?> savePost(Post post) {
    return _datasource.savePost(post);
  }
}
