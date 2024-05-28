import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/permission/app_permission.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final appPermission = AppPermission();

  PermissionCubit() : super(const PermissionState()) {
    initialAuthorizationCheck();
  }

  void initialAuthorizationCheck() async {
    final status = await appPermission.authorizationCheck();

    emit(state.copyWith(status: status));
  }

  void requestAuthorization() async {
    final status = await appPermission.requestAuthorization();

    emit(state.copyWith(status: status));
    _getTokenFCM();
  }

  void _getTokenFCM() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    // ignore: avoid_print
    print(token);
  }
}
