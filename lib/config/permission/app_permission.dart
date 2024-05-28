import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppPermission {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final localNotification = FlutterLocalNotificationsPlugin();

  Future<AuthorizationStatus> authorizationCheck() async {
    final firebaseAuthorizationStatus = await _authorizationStatus();
    return firebaseAuthorizationStatus;

    //LocalNotificationsPermission no requerido con FCM
    // final localNotificationStatus = await _localAuthorizationStatus();

    // return Future(() {
    //   if (localNotificationStatus == null) {
    //     return AuthorizationStatus.notDetermined;
    //   }
    //   if (!localNotificationStatus) return AuthorizationStatus.denied;

    //   return firebaseAuthorizationStatus;
    // });
  }

  Future<AuthorizationStatus> _authorizationStatus() async {
    final setting = await messaging.getNotificationSettings();
    return setting.authorizationStatus;
  }

  //LocalNotificationsPermission no requerido con FCM
  // Future<bool?> _localAuthorizationStatus() async {
  //   final localNotificationAndroid =
  //       localNotification.resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>();

  //   if (localNotificationAndroid == null) return null;

  //   return localNotificationAndroid.areNotificationsEnabled();
  // }

  Future<AuthorizationStatus> requestAuthorization() async {
    final settings = await _firebaseRequestNotificationPermission();
    return settings.authorizationStatus;

    //LocalNotificationsPermission no requerido con FCM
    // final localNotification =
    //     await _localRequestNotificationPermission() ?? false;

    // return localNotification
    //     ? settings.authorizationStatus
    //     : AuthorizationStatus.denied;
  }

  Future<NotificationSettings> _firebaseRequestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    return settings;
  }

  //LocalNotificationsPermission no requerido con FCM
  // Future<bool?> _localRequestNotificationPermission() async {
  //   final localNotificationAndroid =
  //       localNotification.resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>();

  //   return localNotificationAndroid?.requestNotificationsPermission();
  // }
}
