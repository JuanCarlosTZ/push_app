part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final List<Post> posts;

  const NotificationState({
    this.posts = const [],
  });

  NotificationState copyWith({
    AuthorizationStatus? status,
    List<Post>? posts,
  }) {
    return NotificationState(
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object?> get props => [posts];
}
