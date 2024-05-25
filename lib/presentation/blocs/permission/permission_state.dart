part of 'permission_cubit.dart';

class PermissionState extends Equatable {
  final AuthorizationStatus status;
  const PermissionState([this.status = AuthorizationStatus.notDetermined]);

  PermissionState copyWith({AuthorizationStatus? status}) {
    return PermissionState(status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
