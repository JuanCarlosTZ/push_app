part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class AuthorizationStatusChanged extends NotificationEvent {
  final AuthorizationStatus status;

  AuthorizationStatusChanged(this.status);
}
