import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
            icon: 'assets/icons/menu_dashboard.svg',
          ),
          DrawerListTile(
            title: 'Notifiche',
            onTap: () {},
            icon: 'assets/icons/menu_notification.svg',
          ),
          DrawerListTile(
            title: 'Profilo',
            onTap: () {},
            icon: 'assets/icons/menu_profile.svg',
          ),
          DrawerListTile(
            title: 'Impostazioni',
            onTap: () {},
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
