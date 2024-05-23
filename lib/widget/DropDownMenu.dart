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
  final Function(String?) onChange;
  final selectOption;

  const DropDown({
    super.key,
    this.underline,
    this.icon,
    this.style,
    this.hintStyle,
    this.dropdownColor,
    this.iconEnabledColor,
    this.itemList,
    required this.onChange,
    required this.selectOption,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<String>(
      value: itemList?[selectOption.index],
      underline: underline,
      icon: icon,
      dropdownColor: dropdownColor,
      style: style,
      iconEnabledColor: iconEnabledColor,
      onChanged: (String? newValue) {
        onChange(newValue);
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
