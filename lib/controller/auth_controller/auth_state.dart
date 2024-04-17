part of "auth_controller.dart";

enum AuthenticatedState {
  authenticated,
  unauthenticated,
  unknown,
}

class AuthenticationState extends Equatable{
  final AuthenticatedState status;
  final AuthUser user;

  const AuthenticationState._({
    required this.status,
    this.user = AuthUser.empty,
  });

  const AuthenticationState.authenticated(AuthUser user) : this._(status: AuthenticatedState.authenticated, user: user);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticatedState.unauthenticated);

  const AuthenticationState.unknown() : this._(status: AuthenticatedState.unknown);

  @override
  List<Object?> get props => [status, user];
}