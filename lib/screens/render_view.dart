// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/MenuAppController.dart';
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/utils/responsive.dart';
import 'package:condivisionericette/widget/side_menu.dart';

class RenderScreen extends ConsumerWidget {
  const RenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAppController = ref.watch(menuAppControllerProvider);
    final pageController = ref.watch(pageControllerProvider);

    return Scaffold(
      key: menuAppController.scaffoldKey,
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
            child: pageController.currentPage,
          ),
        ],
      )),
    );
  }
}
