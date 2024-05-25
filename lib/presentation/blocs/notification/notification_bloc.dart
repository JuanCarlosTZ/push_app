import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/helpers/helper.dart';

import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/domain/entities/post.dart';

import 'package:push_app/firebase_options.dart';
import 'package:push_app/infraestructure/datacources/storaged_local_post_datasource.dart';
import 'package:push_app/infraestructure/mappers/remote_message_model.dart';
import 'package:push_app/infraestructure/repositories/local_post_repository_imp.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    NotificationBloc.initializeFirebaseInteratives();
    NotificationBloc.initializeFirebaseBackgrounddMessaging();
  }

  static void initializeFirebaseBackgrounddMessaging() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void initializeFirebaseInteratives() {
    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingOpennedApp);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await initializeFCM();

    final bloc = NotificationBloc();
    bloc._handleRemoteMessage(message);
  }

  static Future<void> _firebaseMessagingOpennedApp(
      RemoteMessage message) async {
    await initializeFCM();
    appRouter.push(getDetailPath(getMessageId(message)));
  }

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final localRepository = LocalPostRepositoryImp(StoragedLocalPostDatasource());

  NotificationBloc() : super(const NotificationState()) {
    on<AuthorizationStatusChanged>(_authorizationStatusChanged);
    on<NotificationReciver>(_notificationReciver);
    on<LoadNotifications>(_loadNotifications);

    _initialAuthorizationCheck();
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
    await _savePost(event.post);
    List<Post> posts = [event.post, ...state.posts];

    emit(state.copyWith(posts: posts));
  }

  void _initialAuthorizationCheck() async {
    final setting = await messaging.getNotificationSettings();
    add(AuthorizationStatusChanged(setting.authorizationStatus));
  }

  void _initializeFirebaseForengroundMessaging() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final post = RemoteMessageModel.toPost(message);
    add(NotificationReciver(post));
  }

  void requestAuthorization() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(AuthorizationStatusChanged(settings.authorizationStatus));
    _getTokenFCM();
  }

  void _getTokenFCM() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    // ignore: avoid_print
    print(token);
  }

  Post? postById(String postId) {
    final post = state.posts.where((post) => post.postId == postId).firstOrNull;
    return post;
  }

  Future<void> _savePost(Post post) async {
    await localRepository.savePost(post);
  }

  Future<void> loadPosts() async {
    final posts = await localRepository.getPosts();

    add(LoadNotifications(posts));
  }
}
