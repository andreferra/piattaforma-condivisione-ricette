import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';

class RoundedButtonStyle extends StatelessWidget {
  final double orizzontalePadding;
  final double verticalePadding;
  final String title;
  final Color? bgColor;
  final Color? textColor;
  const RoundedButtonStyle({
    super.key,
    this.orizzontalePadding = 18,
    this.verticalePadding = 18,
    this.bgColor = primaryColor,
    this.textColor = Colors.white,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalePadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
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
