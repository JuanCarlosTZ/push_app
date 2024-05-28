import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/post.dart';

import 'package:push_app/infraestructure/datacources/storaged_local_post_datasource.dart';
import 'package:push_app/infraestructure/mappers/remote_message_model.dart';
import 'package:push_app/infraestructure/repositories/local_post_repository_imp.dart';

part 'notification_event.dart';
part 'notification_state.dart';

typedef ShowLocalNotification = void Function(Post post);

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final localRepository = LocalPostRepositoryImp(StoragedLocalPostDatasource());
  final ShowLocalNotification? showLocalNotification;
  final Stream<RemoteMessage>? onForengroundNotificationMessage;

  NotificationBloc({
    this.showLocalNotification,
    this.onForengroundNotificationMessage,
  }) : super(const NotificationState()) {
    on<AuthorizationStatusChanged>(_authorizationStatusChanged);
    on<NotificationReciver>(_notificationReciver);
    on<LoadNotifications>(_loadNotifications);

    _initializeFirebaseForengroundMessaging();
    loadPosts();
  }

  void _authorizationStatusChanged(
    AuthorizationStatusChanged event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _loadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(posts: event.post));
  }

  void _notificationReciver(
    NotificationReciver event,
    Emitter<NotificationState> emit,
  ) async {
    final isarId = await _savePost(event.post);
    if (isarId == null) return;

    final post = event.post.copyWith(isarId: isarId);
    List<Post> posts = [post, ...state.posts];

    if (showLocalNotification != null) showLocalNotification!(post);

    emit(state.copyWith(posts: posts));
  }

  void _initializeFirebaseForengroundMessaging() {
    onForengroundNotificationMessage?.listen(handleRemoteMessage);
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final post = RemoteMessageModel.toPost(message);

    add(NotificationReciver(post));
  }

  Future<void> handleRemoveNotification(Post post) async {
    await _removePost(post);
    loadPosts();
  }

  Post? postById(String postId) {
    final post = state.posts.where((post) => post.postId == postId).firstOrNull;
    return post;
  }

  Future<int?> _savePost(Post post) async {
    return await localRepository.savePost(post);
  }

  Future<void> _removePost(Post post) async {
    await localRepository.removePost(post);
  }

  Future<void> loadPosts() async {
    final posts = await localRepository.getPosts();

    add(LoadNotifications(posts));
  }
}
