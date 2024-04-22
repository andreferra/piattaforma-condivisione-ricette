import 'package:condivisionericette/screens/profile_screen/components/buttonInfo.dart';
import 'package:condivisionericette/screens/profile_screen/components/editPrefAlimentari.dart';
import 'package:condivisionericette/screens/profile_screen/components/editProfile.dart';
import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<ProfileState>(profileProvider, (previous, current) {
      if (current.status.isSubmissionInProgress) {
        LoadingSheet.show(context);
      } else if (current.status.isSubmissionFailure) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "${current.errorMessage}");
      } else if (current.status.isSubmissionSuccess) {
        SnackBar snackBar = SnackBar(
          content: Text("Profilo aggiornato con successo"),
          duration: const Duration(seconds: 2),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return const SafeArea(
      child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EditProfile(),
                  EditPrefAlimentari(),
                ],
              ),
              SizedBox(height: defaultPadding),
              SaveProfile(),
            ],
          )),
    );
  }
}
