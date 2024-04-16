import 'dart:async';

import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part "auth_state.dart";

final authProvider = StateNotifierProvider<AuthController, AuthenticationState>(
  (ref) => AuthController(ref.watch(authRepoProvider))
);


class AuthController extends StateNotifier<AuthenticationState> {
  final AuthenticationRepository _authRepo;
  late final StreamSubscription _streamSubscription;

  AuthController(this._authRepo) : super(const AuthenticationState.unknown()) {
    _streamSubscription = _authRepo.user.listen((user) => onUserChanged(user));
  }

  void onUserChanged(AuthUser user){
    if(user.isEmpty)
      {
        state = const AuthenticationState.unauthenticated();
      } else{
        state = AuthenticationState.authenticated(user);
      }
    }
    Future<AuthUser> refreshUser() async {
      final user = await _authRepo.getUserFrommDatabase();
      onUserChanged(user);
      return user;
    }

    Future<void> signOut() async {
      await _authRepo.signOut();
    }

    @override
    void dispose() {
      _streamSubscription.cancel();
      super.dispose();
    }
}