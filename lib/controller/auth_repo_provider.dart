// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the AuthenticationRepository
// This provider is used to provide an instance of AuthenticationRepository
// to the widgets that are listening to it.
// The instance is created using the default constructor of AuthenticationRepository.
final authRepoProvider = Provider<AuthenticationRepository>((_) => AuthenticationRepository());

final firebaseRepoProvider = Provider<FirebaseRepository>((ref) => FirebaseRepository());
