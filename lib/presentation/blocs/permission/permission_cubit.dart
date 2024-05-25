import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  PermissionCubit() : super(const PermissionState()) {
    _initialAuthorizationCheck();
  }

  void _initialAuthorizationCheck() async {
    final setting = await messaging.getNotificationSettings();

    emit(state.copyWith(status: setting.authorizationStatus));
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

    emit(state.copyWith(status: settings.authorizationStatus));
    _getTokenFCM();
  }

  void _getTokenFCM() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    // ignore: avoid_print
    print(token);
  }
}
