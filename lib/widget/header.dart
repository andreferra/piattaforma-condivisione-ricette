// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:condivisionericette/controller/MenuAppController.dart';
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/search_screen/controller/search_controller.dart';
import 'package:condivisionericette/screens/search_screen/search_screen.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/responsive.dart';

class Header extends ConsumerWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> nameList = [
      'Dashboard',
      'Le mie ricette',
      'Notifiche',
      'Profilo',
      'Impostazioni',
      '',
      'Messaggi',
      'Gaming',
    ];

    final page = ref.watch(pageControllerProvider);
    String pageName = nameList[page.currentIndex];

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ref.read(menuAppControllerProvider.notifier).openDrawer();
            },
          ),
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(pageName,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
        InkWell(
          onTap: () {
            page.setPage(3);
          },
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const ProfileCard(),
        ),
      ],
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/profile_pic.png',
            image: user.photoURL!,
            width: 38,
            height: 38,
            fit: BoxFit.cover,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(user.nickname!),
            ),
        ],
      ),
    );
  }
}

class SearchField extends ConsumerWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = ref.watch(searchControllerProvider).searchValue;
    final serachController = ref.read(searchControllerProvider.notifier);

    final TextEditingController controller = TextEditingController();

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Cerca",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            serachController.setSearchValue(controller.text);

            if (searchValue!.isNotEmpty && controller.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
