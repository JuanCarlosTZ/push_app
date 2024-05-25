part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final AuthorizationStatus status;
  final List<Post> posts;

  const NotificationState({
    this.status = AuthorizationStatus.notDetermined,
    this.posts = const [],
  });

  NotificationState copyWith({
    AuthorizationStatus? status,
    List<Post>? posts,
  }) {
    return NotificationState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object?> get props => [status, posts];
}
