import 'package:condivisionericette/screens/login_screen/controller/login_controller.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final signInController = ref.read(loginProvider.notifier);
    final bool isValidated = loginState.status.isValidated;
    return AnimatedButton(
      onTap: isValidated
          ? () => signInController.signInWithEmailAndPassword()
          : null,
      child: const RoundedButtonStyle(title: "Accedi"),
    );
  }
}
