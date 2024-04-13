import 'package:condivisionericette/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbMethod {
  final _firebase = FirebaseFirestore.instance;

  Future<String> addUserToDb(User user) async {
    try {
      await _firebase.collection('users').doc(user.id).set(user.toJson());
      return 'ok';
    } on FirebaseException catch (e) {
      return 'Error: ${e.code}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<User> getUserFromDb(String id) async {
    try {
      final user = await _firebase.collection('users').doc(id).get();
      return User.fromJson(user.data()!);
    } on FirebaseException catch (e) {
      throw 'Error: ${e.code}';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateOnlineStatus(String id, bool isOnline) async {
    try {
      await _firebase
          .collection('users')
          .doc(id)
          .update({'isLogged': isOnline});
      return 'ok';
    } on FirebaseException catch (e) {
      return 'Error: ${e.code}';
    } catch (e) {
      return e.toString();
    }
  }
}
