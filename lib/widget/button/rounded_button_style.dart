// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';

class RoundedButtonStyle extends StatelessWidget {
  final double orizzontalePadding;
  final double verticalePadding;
  final String title;
  final Color? bgColor;
  final Color? textColor;
  const RoundedButtonStyle({
    super.key,
    this.orizzontalePadding = 14,
    this.verticalePadding = 14,
    this.bgColor = buttonBg,
    this.textColor = Colors.white,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalePadding,
        horizontal: orizzontalePadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
