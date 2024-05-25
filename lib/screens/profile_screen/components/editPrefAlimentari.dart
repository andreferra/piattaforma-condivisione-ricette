// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/profile_screen/components/allergeni.dart';
import 'package:condivisionericette/screens/profile_screen/components/interessiAlimentari.dart';
import 'package:condivisionericette/screens/profile_screen/components/preferenzeAlimentari.dart';

class EditPrefAlimentari extends ConsumerWidget {
  const EditPrefAlimentari({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double defaultHight = MediaQuery.of(context).size.height * 0.09;
    double defaultPadding = MediaQuery.of(context).size.width * 0.03;

    final user = ref.watch(authProvider).user;
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      primary: false,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          children: [
            SizedBox(height: defaultHight * 1.1),
            InteressiAlimentari(valoreIniziale: user.interessiCulinari!),
            SizedBox(height: defaultHight * 0.5),
            AlimentiPreferitiField(valoreIniziale: user.prefAlimentari!),
            SizedBox(height: defaultHight * 0.5),
            AllergeniField(valoreIniziale: user.allergie!),

          ],
        ),
      ),
    );
  }
}
