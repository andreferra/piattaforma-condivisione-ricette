// Flutter imports:
// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/admin_screen/admin_screen.dart';
import 'package:condivisionericette/screens/authentication/login_screen/login_screen.dart';
import 'package:condivisionericette/screens/render_view.dart';
import 'package:condivisionericette/utils/constant.dart';
// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    Widget getPage() {
      if (authState.status == AuthenticatedState.authenticated) {
        return const RenderScreen();
      } else if (authState.status == AuthenticatedState.unauthenticated) {
        return const LoginScreen();
      } else if (authState.status == AuthenticatedState.admin) {
        return const AdminScreen();
      } else {
        return const LoginScreen();
      }
    }

    return MaterialApp(
      title: 'RecipeBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white.withOpacity(0.8)),
      ),
      home: getPage(),
    );
  }
}
