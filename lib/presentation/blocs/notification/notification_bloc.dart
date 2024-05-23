import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_app/firebase_options.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _initializeFirebaseBackgrounddMessaging();
  }

  static void _initializeFirebaseBackgrounddMessaging() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await initializeFCM();

    print("Handling a background message: ${message.messageId}");
  }

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationBloc() : super(const NotificationState()) {
    on<AuthorizationStatusChanged>(_authorizationStatusChanged);

    _initialAuthorizationCheck();
    _initializeFirebaseForengroundMessaging();
  }

  void _authorizationStatusChanged(
    AuthorizationStatusChanged event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _initialAuthorizationCheck() async {
    final setting = await messaging.getNotificationSettings();
    add(AuthorizationStatusChanged(setting.authorizationStatus));
  }

  void _initializeFirebaseForengroundMessaging() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;
    print('Message also contained a notification: ${message.notification}');
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
    print(token);
  }
}
