import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/backend/DbMethod.dart';
import 'package:condivisionericette/controller/UserController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:condivisionericette/model/User.dart' as model;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthMethod {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DbMethod().getUserFromDb(cred.user!.uid).then((value) async {
        value.isLogged = true;
        await ProviderContainer().read(userProvider).setUser(
              model.User.fromJson(value.toJson()),
            );
        DbMethod().updateOnlineStatus(value.id, true);
      });
      return 'ok';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Error: ${e.code}';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpWithEmailAndPassword(String email, String password,
      String nome, String nickname, String numeroTelefono) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = model.User(
        id: credential.user!.uid,
        name: nome,
        email: email,
        password: password,
        phone: numeroTelefono,
        nickname: nickname,
        dataRegistrazione: Timestamp.fromDate(DateTime.now()),
        dataUltimoAccesso: Timestamp.fromDate(DateTime.now()),
        isLogged: false,
      );

      // Aggiungere l'utente al database
      await DbMethod().addUserToDb(user);
      return 'ok';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'Error: ${e.code}';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signOut() async {
    try {
      final user = UserController().user;
      debugPrint('User: ${user.id} is logged out');
      user.isLogged = false;
      await DbMethod().updateOnlineStatus(user.id, false);
      await _firebaseAuth.signOut();
      return "ok";
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }
}
