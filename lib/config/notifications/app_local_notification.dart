import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/domain/entities/post.dart';

typedef HandlerRemoteMessage = void Function(RemoteMessage message);

class AppLocalNotification {
  static Future<void> initialize() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onDidReceiveNotificationResponse(NotificationResponse response) {
    appRouter.go(getDetailPath(response.payload ?? ''));
  }

  static void showLocalNotification(Post post) {
    const androidDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.high,
      priority: Priority.high,
      icon: 'app_icon',
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    flutterLocalNotificationsPlugin.show(
      post.isarId ?? 0,
      post.title,
      post.caption,
      notificationDetails,
      payload: post.postId,
    );
  }
}
