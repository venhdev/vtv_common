// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

enum AuthStatus {
  unknown,
  authenticating,
  authenticated,
  unauthenticated, //guest
}

enum AuthRedirect {
  loginSuccess,
  logoutSuccess,
  registerSuccess,
  changePasswordSuccess,
  updateProfileSuccess,
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.auth,
    this.message,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticating() : this._(status: AuthStatus.authenticating);
  const AuthState.authenticated(AuthEntity auth, {String? message})
      : this._(
          status: AuthStatus.authenticated,
          auth: auth,
          message: message,
        );
  const AuthState.unauthenticated({String? message})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
        );

  const AuthState.error({String? message})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
        );

  final AuthStatus status;
  final AuthEntity? auth;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  String? get currentUsername => auth?.userInfo.username;
  bool get isVendor => auth?.userInfo.roles!.contains(Role.VENDOR) ?? false;
  bool get isDeliver => auth?.userInfo.roles!.contains(Role.DELIVER) ?? false;
  bool get isProvider => auth?.userInfo.roles!.contains(Role.PROVIDER) ?? false;
  bool get isManager => auth?.userInfo.roles!.contains(Role.MANAGER) ?? false;

  @override
  List<Object?> get props => [
        status,
        auth,
        message,
      ];

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? auth,
    String? message,
  }) {
    return AuthState._(
      status: status ?? this.status,
      auth: auth ?? this.auth,
      message: message ?? this.message,
    );
  }
}
