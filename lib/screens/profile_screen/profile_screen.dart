import 'package:condivisionericette/screens/profile_screen/components/buttonInfo.dart';
import 'package:condivisionericette/screens/profile_screen/components/editProfile.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ],
              ),
              SizedBox(height: defaultPadding),
              SaveProfile(),
            ],
          )),
    );
  }
}
