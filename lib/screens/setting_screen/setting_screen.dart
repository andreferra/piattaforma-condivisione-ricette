// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/setting_screen/components/delete_account_component.dart';
import 'package:condivisionericette/screens/setting_screen/components/edit_email_component.dart';
import 'package:condivisionericette/screens/setting_screen/components/edit_password_component.dart';
import 'package:condivisionericette/screens/setting_screen/components/notification_component.dart';
import 'package:condivisionericette/screens/setting_screen/controller/setting_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:condivisionericette/widget/loading_errors.dart';

/// Classe per gestire le impostazioni dell'applicazione
/// Impostazioni presenti:
/// - Cambio password
/// - Cambio email
/// - Notifiche
/// - Elimina account
/// - Change log
class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final settingController = ref.read(settingProvider.notifier);

    ref.listen<SettingState>(settingProvider, (previous, current) {
      if (current.status.isSubmissionInProgress) {
        LoadingSheet.show(context);
      } else if (current.status.isSubmissionFailure) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "${current.errorMessage}");
      } else if (current.status.isSubmissionSuccess) {
        SnackBar snackBar = const SnackBar(
          content: Text("Impostazioni aggiornate con successo"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return SingleChildScrollView(
      primary: false,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Header(),
          const SizedBox(height: defaultPadding),
          EditEmail(valoreInziale: user.user.email!),
          const SizedBox(height: defaultPadding),
          EditPassword(valoreInziale: user.user.password!),
          const SizedBox(height: defaultPadding * 2),
          NotificationSetting(valoreIniziale: user.user.notification!),
          const SizedBox(height: defaultPadding * 2),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.48,
            child: AnimatedButton(
                onTap: () async {
                  await settingController.aggiornaImpostazioni(user.user);
                },
                child: const RoundedButtonStyle(
                    title: "Aggiorna le impostazioni")),
          ),
          const SizedBox(height: defaultPadding * 2),
          Divider(
            color: Colors.white.withOpacity(0.7),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: defaultPadding * 2),
          const DeleteAccount(),
          const SizedBox(height: defaultPadding * 2),
          Divider(
            color: Colors.white.withOpacity(0.7),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: defaultPadding * 2),
        ],
      ),
    );
  }
}
