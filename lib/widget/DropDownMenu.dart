import 'package:condivisionericette/screens/search_screen/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropDown extends ConsumerWidget {
  final Widget? underline;
  final Widget? icon;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? dropdownColor;
  final Color? iconEnabledColor;
  final List<String>? itemList;

  const DropDown({
    super.key,
    this.underline,
    this.icon,
    this.style,
    this.hintStyle,
    this.dropdownColor,
    this.iconEnabledColor,
    this.itemList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectOption = ref.watch(searchControllerProvider).dropDownValue;

    final searchController = ref.watch(searchControllerProvider.notifier);

    return DropdownButton<String>(
      value: itemList?[selectOption.index],
      underline: underline,
      icon: icon,
      dropdownColor: dropdownColor,
      style: style,
      iconEnabledColor: iconEnabledColor,
      onChanged: (String? newValue) {
        if (newValue == "All") {
          searchController.setDropDownValue(SearchType.all);
        } else if (newValue == "Users") {
          searchController.setDropDownValue(SearchType.users);
        } else if (newValue == "Recipes") {
          searchController.setDropDownValue(SearchType.recipes);
        }
      },
      hint: Text("Select filter", style: hintStyle),
      items: itemList
          ?.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                textAlign: TextAlign.center,
              )))
          .toList(),
    );
  }
}
