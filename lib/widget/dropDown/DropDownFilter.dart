import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropDownFilter extends ConsumerWidget {
  final Widget? underline;
  final Widget? icon;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? dropdownColor;
  final Color? iconEnabledColor;
  final List<String>? itemList;
  final Function(String?) onChange;
  final int? selectOption;

  const DropDownFilter({
    Key? key,
    this.underline,
    this.icon,
    this.style,
    this.hintStyle,
    this.dropdownColor,
    this.iconEnabledColor,
    this.itemList,
    required this.onChange,
    this.selectOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<String>(
      value: itemList?[selectOption!],
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
