import 'package:condivisionericette/screens/setting_screen/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSetting extends ConsumerWidget {
  final bool valoreIniziale;

  const NotificationSetting({super.key, required this.valoreIniziale});

  List<DropdownMenuItem<bool>> get items => [
        const DropdownMenuItem(
          value: true,
          alignment: Alignment.center,
          child: Text("Abilita le notifiche"),
        ),
        const DropdownMenuItem(
          value: false,
          alignment: Alignment.center,
          child: Text("Disattiva le notifiche"),
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingController = ref.watch(settingProvider.notifier);
    final notification = ref.watch(settingProvider).notification;
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.48   ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Notifiche",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
                child: DropdownButton(
              isExpanded: true,
              items: items,
              value: notification ?? valoreIniziale,
              onChanged: (value) {
                settingController.onNotificationChanged(value);
              },
            ))
          ],
        ));
  }
}
