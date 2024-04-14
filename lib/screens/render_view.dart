import 'package:condivisionericette/controller/MenuAppController.dart';
import 'package:condivisionericette/utils/responsive.dart';
import 'package:condivisionericette/widget/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RenderScreen extends StatelessWidget {
  const RenderScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: child,
          ),
        ],
      )),
    );
  }
}
