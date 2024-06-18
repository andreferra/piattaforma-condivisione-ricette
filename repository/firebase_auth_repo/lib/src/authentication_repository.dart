import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_repo/src/firestore_repository.dart';

import 'auth_user.dart';

/// Repository responsible for handling authentication related operations.
class AuthenticationRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseRepo = FirebaseRepository();

  /// Stream of [AuthUser] which will emit the current user each time
  /// the authentication state changes.
  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return AuthUser.empty;
      } else {
        final user = await _firebaseRepo.getUserFromDatabase(firebaseUser.uid);
        return user;
      }
    });
  }

  /// Signs up a user with the given [email], [password], [name], [nickname], and [phone].
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String nickname,
    required String phone,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = AuthUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        nickname: nickname,
        phone: phone,
        gameActive: false,
        password: password,
        emailVerified: credential.user!.emailVerified,
        dataRegistrazione: DateTime.now().toIso8601String(),
        dataUltimoAccesso: DateTime.now().toIso8601String(),
        isLogged: true,
        photoURL:
            'https://firebasestorage.googleapis.com/v0/b/gestione-rice.appspot.com/o/icon.png?alt=media&token=75323f65-8735-4557-a288-55565a9ce060',
        bio: '',
        prefAlimentari: const [],
        allergie: const [],
        interessiCulinari: const [],
        notification: true,
        follower: const [],
        newNotifiche: false,
        following: const [],
        posts: 0,
        listaNotifiche: const [],
      );
      await _firebaseRepo.saveUserInDatabase(user);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure(e.code);
    }
  }

  /// Signs in a user with the given [email] and [password].
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure(e.code);
    }
  }

  /// Sends a password reset email to the given [email].
  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code);
    }
  }

  /// Deletes the account of the given [userId].
  Future<void> deleteAccount(String userId) async {
    try {
      await _firebaseRepo.deleteUserFromDatabase(userId);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw DeleteAccountFailure(e.code);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      final user = await _firebaseRepo
          .getUserFromDatabase(_firebaseAuth.currentUser!.uid);
      await _firebaseRepo.updateUserLogStatus(user.uid, false);
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (_) {
      throw SignOutFailure();
    }
  }

  /// Checks if the given [email] is already in use.
  Future<bool> checkEmail(String email) async {
    try {
      return _firebaseRepo.checkUserEmail(email);
    } on FirebaseAuthException catch (e) {
      throw CheckEmailFailure(e.code);
    }
  }

  Future<String> resetPassword(String text) async {
    try {
      String res = "";
      await _firebaseAuth.sendPasswordResetEmail(email: text).then((value) {
        res = "Email di recupero inviata";
      }).catchError((e) {
        res = "Email non presente nel sistema";
      });
      return res;
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code);
    }
  }

  ///aggiunta funzione per aggiornare l'email
  Future<String> updateEmail(String email, String password) async {
    try {
      String res = "";
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser!.email != email) {
        await _firebaseAuth.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: currentUser.email!, password: password));
        await _firebaseAuth.currentUser!.verifyBeforeUpdateEmail(email);

        res = "ok";
      }

      return res;
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code).toString();
    }
  }

  ///aggiunta funzione per aggiornare la password
  Future<String> updatePassword(
      String email, String password, String oldPassword) async {
    try {
      String res = "";
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser!.email == email &&
          password.isNotEmpty &&
          oldPassword.isNotEmpty) {
        // riautentico l'utente
        await _firebaseAuth.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: currentUser.email!, password: oldPassword));
        //modifico la password
        await _firebaseAuth.currentUser!.updatePassword(password);

        //aggiorno la password nel database
        await _firebaseRepo
            .updateEmailAndPassword(_firebaseAuth.currentUser!.email!, password,
                _firebaseAuth.currentUser!.uid)
            .then((value) {
          res = "ok";
        }).catchError((e) {
          res = "error";
        });
      }

      return res;
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code).toString();
    }
  }
}

class CheckEmailFailure implements Exception {
  final String code;

  const CheckEmailFailure(this.code);
}

class DeleteAccountFailure implements Exception {
  final String code;

  const DeleteAccountFailure(this.code);
}

/// Exception thrown when sign up with email and password fails.
class SignUpWithEmailAndPasswordFailure implements Exception {
  final String code;

  const SignUpWithEmailAndPasswordFailure(this.code);
}

/// Exception thrown when sign in with email and password fails.
class SignInWithEmailAndPasswordFailure implements Exception {
  final String code;

  const SignInWithEmailAndPasswordFailure(this.code);
}

/// Exception thrown when forgot password operation fails.
class ForgotPasswordFailure implements Exception {
  final String code;

  @override
  String toString() {
    return 'ForgotPasswordFailure: $code';
  }

  const ForgotPasswordFailure(this.code);
}

/// Exception thrown when sign out operation fails.
class SignOutFailure implements Exception {}
