import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/profile_screen/components/allergeni.dart';
import 'package:condivisionericette/screens/profile_screen/components/bio.dart';
import 'package:condivisionericette/screens/profile_screen/components/nickname.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends ConsumerWidget {
  const EditProfile({super.key});

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
            const _EditImage(),
            SizedBox(height: defaultHight),
            SizedBox(
              child: Column(
                children: [
                  NicknameField(valoreIniziale: user.nickname!),
                  SizedBox(height: defaultHight * 0.5),
                  BioField(valoreIniziale: user.bio!),
                  SizedBox(height: defaultHight * 0.5),
                  AllergeniField(valoreIniziale: user.allergie!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EditImage extends ConsumerWidget {
  const _EditImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double defaultPadding = MediaQuery.of(context).size.width * 0.02;

    final user = ref.watch(authProvider).user;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : const AssetImage('assets/images/profile_pic.png')
                  as ImageProvider,
        ),
        SizedBox(height: defaultPadding),
        TextButton(
          onPressed: () {},
          child: const Text('Change Profile Image'),
        ),
      ],
    );
  }
}
