part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class AuthorizationStatusChanged extends NotificationEvent {
  final AuthorizationStatus status;
  AuthorizationStatusChanged(this.status);
}

class NotificationReciver extends NotificationEvent {
  final Post post;
  NotificationReciver(this.post);
}

class LoadNotifications extends NotificationEvent {
  final List<Post> post;
  LoadNotifications(this.post);
}
