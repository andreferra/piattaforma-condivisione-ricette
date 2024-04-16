import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/backend/AuthMethod.dart';
import 'package:condivisionericette/model/User.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = ChangeNotifierProvider<UserController>((ref) {
  return UserController();
});

class UserController extends ChangeNotifier {
  User _user;

  UserController({
    User? user,
  }) : _user = user ?? User(
    id: '',
    name: '',
    email: '',
    password: '',
    phone: '',
    nickname: '',
    dataRegistrazione: Timestamp.fromDate(DateTime.now()),
    dataUltimoAccesso: Timestamp.fromDate(DateTime.now()),
    isLogged: false,
  );

  User get user => _user;

  void _updateUserState(User newUser) {
    _user = newUser;
    notifyListeners();
  }

    Future<void> setUser(User newUser) async {
      try {
        _updateUserState(newUser);
        debugPrint('User: ${_user.name} is logged in');
      } catch (e) {
        debugPrint('Error: $e');
      }
    }

    void resetUser() {
      _updateUserState(
        User(
          id: '',
          name: '',
          email: '',
          password: '',
          phone: '',
          nickname: '',
          dataRegistrazione: Timestamp.fromDate(DateTime.now()),
          dataUltimoAccesso: Timestamp.fromDate(DateTime.now()),
          isLogged: false,
        ),
      );
    }

    Future<String> logout(BuildContext context) async {
      _user.isLogged = false;
      await AuthMethod().signOut().then((value) {
        if (value == 'ok') {
          debugPrint('User: ${_user.name} is logged out');
          resetUser();
        } else {
          showErrorSnackbar(context, value);
        }
      });
      notifyListeners();
      return 'ok';
    }
  }