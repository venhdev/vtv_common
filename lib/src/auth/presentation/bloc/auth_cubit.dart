import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/base.dart';
import '../../../core/constants/constant_messages.dart';
import '../../../core/constants/types.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/dto/register_params.dart';
import '../../domain/entities/user_info_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecase/check_token.dart';
import '../../domain/usecase/login_with_username_and_password.dart';
import '../../domain/usecase/logout.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
    this._loginWithUsernameAndPasswordUC,
    this._logoutUC,
    this._checkAndGetTokenIfNeededUC,
    this._redirect,
  ) : super(const AuthState.unknown()) {
    onStarted;
    loginWithUsernameAndPassword;
    logout;
    register;
    changePassword;
    editUserProfile;
  }

  final BaseRedirect _redirect;
  final AuthRepository _authRepository;
  final LoginWithUsernameAndPasswordUC _loginWithUsernameAndPasswordUC;
  final LogoutUC _logoutUC;
  final CheckTokenUC _checkAndGetTokenIfNeededUC;

  FutureOr<void> onStarted() async {
    emit(const AuthState.authenticating());
    await _authRepository.retrieveAuth().then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(message: failure.message)),
        (authEntity) async {
          // get new access token if needed
          final resultCheck = await _checkAndGetTokenIfNeededUC(authEntity.accessToken);

          resultCheck.fold(
            (failure) => emit(AuthState.error(message: failure.message)),
            (newAccessToken) {
              log('{GetTokenIfNeededUC} --null if still valid: $newAccessToken');

              //> save to local storage
              if (newAccessToken != null) {
                final newAuth = authEntity.copyWith(accessToken: newAccessToken);
                _authRepository.cacheAuth(newAuth);
                emit(AuthState.authenticated(newAuth));
              } else {
                emit(AuthState.authenticated(authEntity));
              }
            },
          );
        },
      );
    });
  }

  void loginWithUsernameAndPassword({required String username, required String password}) async {
    emit(const AuthState.authenticating());

    await _loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(
        username: username,
        password: password,
      ),
    ).then((respEither) {
      respEither.fold((failure) => emit(AuthState.error(message: failure.message)), (ok) {
        emit(AuthState.authenticated(ok.data!, message: kMsgLoggedInSuccessfully));
        _redirect.go(AuthRedirect.loginSuccess);
      });
    });
  }

  void logout(String refreshToken) async {
    emit(const AuthState.authenticating());
    await _logoutUC(refreshToken).then((respEither) {
      respEither.fold((error) => emit(AuthState.error(message: error.message)), (ok) {
        emit(AuthState.unauthenticated(message: ok.message));
        _redirect.go(AuthRedirect.logoutSuccess);
      });
    });
  }

  void register(RegisterParams params) async {
    emit(const AuthState.authenticating());
    await _authRepository.register(params).then((resultEither) {
      resultEither.fold((error) => emit(AuthState.error(message: error.message)), (ok) {
        emit(AuthState.unauthenticated(message: ok.message)); //user must login after register
        _redirect.go(AuthRedirect.registerSuccess);
      });
    });
  }

  void changePassword({required String oldPassword, required String newPassword}) async {
    // using 'state' to get the previous state (should be authenticated)
    final previousState = state;
    emit(const AuthState.authenticating());
    await _authRepository.changePassword(oldPassword, newPassword).then((resultEither) {
      //? even user change password success or not, keep the user authenticated
      resultEither.fold((error) => emit(previousState.copyWith(message: error.message)), (ok) {
        emit(previousState.copyWith(message: ok.message));
        _redirect.go(AuthRedirect.changePasswordSuccess);
      });
    });
  }

  void editUserProfile({required UserInfoEntity newInfo}) async {
    // using 'state' to get the previous state (should be authenticated)
    final previousState = state;
    emit(const AuthState.authenticating());
    await _authRepository.editUserProfile(newInfo).then((resultEither) {
      resultEither.fold((error) => emit(previousState.copyWith(message: error.message)), (ok) {
        emit(AuthState.authenticated(previousState.auth!.copyWith(userInfo: ok.data), message: ok.message));
        _redirect.go(AuthRedirect.updateProfileSuccess);
      });
    });
  }
}
