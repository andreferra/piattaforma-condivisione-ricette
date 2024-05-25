// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/profile_screen/components/bio.dart';
import 'package:condivisionericette/screens/profile_screen/components/nickname.dart';
import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';

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
    final imagePick = ref.watch(profileProvider).newPhoto;
    final user = ref.watch(authProvider).user;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imagePick != null
              ? Image.memory(imagePick).image
              : user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage('assets/images/profile_pic.png')
                      as ImageProvider,
        ),
        SizedBox(height: defaultPadding),
        TextButton(
          onPressed: () async {
            final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);

            if (image != null) {
              Uint8List file = await image.readAsBytes();
              ref.read(profileProvider.notifier).onNewPhotoChanged(file);
            }
          },
          child: const Text('Modifica immagine profilo'),
        ),
      ],
    );
  }
}
