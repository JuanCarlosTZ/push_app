import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/config/helpers/helper.dart';
import 'package:push_app/config/notifications/app_local_notification.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/firebase_options.dart';
import 'package:push_app/presentation/blocs/notification/notification_bloc.dart';

typedef HandlerRemoteMessage = void Function(RemoteMessage message);

class AppFirebaseNotification {
  static NotificationBloc bloc = NotificationBloc(
    onForengroundNotificationMessage: FirebaseMessaging.onMessage,
    showLocalNotification: AppLocalNotification.showLocalNotification,
  );

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    initializeFirebaseInteratives();
    initializeFirebaseBackgrounddMessaging();
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

    bloc.handleRemoteMessage(message);
  }

  static Future<void> _firebaseMessagingOpennedApp(
      RemoteMessage message) async {
    await initializeFCM();
    appRouter.go(getDetailPath(getMessageId(message)));
  }
}
