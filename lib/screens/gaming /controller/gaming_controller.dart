import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/model/Gaming.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'gaming_state.dart';

final gamingProvider =
    StateNotifierProvider.autoDispose<GamingController, GamingState>(
        (ref) => GamingController(
              ref.watch(firebaseRepoProvider),
              ref.watch(authRepoProvider),
              ref.watch(authProvider).user.gameActive!,
            ));

class GamingController extends StateNotifier<GamingState> {
  final FirebaseRepository _firebaseRepo;
  final AuthenticationRepository _authRepo;
  final bool gameActive;
  GamingController(this._firebaseRepo, this._authRepo, this.gameActive)
      : super(GamingState(
          gameActive: gameActive,
        ));

  void setGaming(Gaming gaming) {
    state = state.copyWith(gaming: gaming);
  }

  void setGameActive(bool gameActive) {
    state = state.copyWith(gameActive: gameActive);
  }

  Future<String> addGamingToUser(String userId) async {
    final result = await _firebaseRepo.addGamingToUser(userId, Gaming.empty());
    return result;
  }
}
