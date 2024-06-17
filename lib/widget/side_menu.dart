// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageControllerProvider);

    final user = ref.watch(authProvider).user;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Image.asset(
              'assets/images/menu_image.png',
              fit: BoxFit.cover,
            ),
          ),
          DrawerListTile(
            title: 'Dashboard',
            onTap: () {
              pageController.setPage(0);
            },
            hasNotification: false,
            icon: 'assets/icons/menu_dashboard.svg',
          ),
          DrawerListTile(
            title: 'Le mie ricette',
            onTap: () {
              pageController.setPage(1);
            },
            hasNotification: false,
            icon: 'assets/icons/menu_recipes.svg',
          ),
          DrawerListTile(
            title: 'Messaggi',
            onTap: () {
              pageController.setPage(6);
            },
            icon: 'assets/icons/messaggi_dashboard.svg',
            hasNotification: false,
          ),
          DrawerListTile(
            title: "Gaming",
            onTap: () {
              pageController.setPage(7);
            },
            icon: 'assets/icons/menu_gaming.svg',
            hasNotification: false,
          ),
          user.notification!
              ? DrawerListTile(
                  title: 'Notifiche',
                  onTap: () {
                    pageController.setPage(2);
                  },
                  icon: 'assets/icons/menu_notification.svg',
                  hasNotification: user.newNotifiche!,
                )
              : Container(),
          DrawerListTile(
            title: 'Profilo',
            onTap: () {
              pageController.setPage(3);
            },
            hasNotification: false,
            icon: 'assets/icons/menu_profile.svg',
          ),
          DrawerListTile(
            title: 'Impostazioni',
            onTap: () {
              pageController.setPage(4);
            },
            hasNotification: false,
            icon: 'assets/icons/menu_setting.svg',
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
    required this.hasNotification,
  });

  final String title, icon;
  final VoidCallback onTap;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
            hasNotification ? Colors.blueAccent : Colors.white54,
            BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: hasNotification ? Colors.blueAccent : Colors.white54),
      ),
    );
  }
}
