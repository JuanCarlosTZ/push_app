part of 'notification_bloc.dart';

class NotificationState {
  final AuthorizationStatus status;

  const NotificationState({this.status = AuthorizationStatus.notDetermined});

  NotificationState copyWith({
    AuthorizationStatus? status,
  }) {
    return NotificationState(
      status: status ?? this.status,
    );
  }
}
