import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';

import '../public_profile_screen.dart';

class ProfileInfoRow extends StatelessWidget {
  final List<ProfileInfoItem> items;

  const ProfileInfoRow(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Text(item.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: primaryColor,
                  ))
        ],
      );
}
