import 'package:condivisionericette/backend/DbMethod.dart';
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/UserController.dart';
import 'package:condivisionericette/model/User.dart';
import 'package:condivisionericette/screens/home_screen/home_screen.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageControllerProvider);

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          DrawerListTile(
            title: 'Home',
            onTap: () {
              pageController.setPage(0);
            },
            icon: 'assets/icons/menu_dashboard.svg',
          ),
          DrawerListTile(
            title: 'Notifiche',
            onTap: () {
              pageController.setPage(1);
            },
            icon: 'assets/icons/menu_notification.svg',
          ),
          DrawerListTile(
            title: 'Profilo',
            onTap: () {
              pageController.setPage(2);
            },
            icon: 'assets/icons/menu_profile.svg',
          ),
          DrawerListTile(
            title: 'Impostazioni',
            onTap: () {
              pageController.setPage(3);
            },
            icon: 'assets/icons/menu_setting.svg',
          ),
          DrawerListTile(
              title: "Logout",
              onTap: () async {
                await ref.watch(userProvider).logout(context).then((value) {
                  if (value == 'ok') {
                    pageController.setPage(0);
                    MaterialPageRoute(builder: (context) => const HomeScreen());
                  } else {
                    showErrorSnackbar(context, value);
                  }
                });
              },
              icon: 'assets/icons/menu_setting.svg'),
          DrawerListTile(
              title: "Update ${ref.watch(userProvider).user.name}",
              onTap: () async {
                final userController = ref.read(userProvider);
                final user = userController.user;
                await DbMethod()
                    .getUserFromDb("mx32OmvxMWZm2YiCTWVq86yfLef1")
                    .then((value) async {
                  debugPrint("name: ${value.toJson()}");
                  await userController.setUser(User.fromJson(value.toJson()));
                  debugPrint("name 2: ${userController.user.name} ");
                });
              },
              icon: 'assets/icons/menu_setting.svg'
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title, icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        icon,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
