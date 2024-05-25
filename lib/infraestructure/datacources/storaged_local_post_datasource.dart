import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:push_app/domain/datasources/local_post_datasource.dart';
import 'package:push_app/domain/entities/post.dart';

class StoragedLocalPostDatasource extends LocalPostDatasource {
  late final Future<Isar> db;

  StoragedLocalPostDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationCacheDirectory();
      await Isar.open([PostSchema], directory: dir.path, inspector: true);
    }

    return await Future.value(Isar.getInstance());
  }

  @override
  Future<List<Post>> getPosts({int limit = 10, int offset = 0}) async {
    final isar = await db;
    return await isar.posts.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<bool> removePost(Post post) async {
    if (post.isarId == null) return false;
    final isar = await db;

    try {
      return isar.writeTxn(() => isar.posts.delete(post.isarId!));
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<int?> savePost(Post post) async {
    final isar = await db;
    try {
      return isar.writeTxn(() => isar.posts.put(post));
    } catch (ex) {
      return null;
    }
  }
}
