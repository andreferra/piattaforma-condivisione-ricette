import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String hintText;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? errorText;
  final String? valoreIniziale;
  final bool? enable;
  final String? labelText;
  final bool obscureText;
  final void Function()? onTap;
  final int? minLines;
  final String? testoSopra;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  const TextInputField({
    super.key,
    this.controller,
    this.enable = true,
    this.minLines,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.testoSopra,
    this.prefixIcon,
    this.labelText,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.onTap,
    required this.onChanged,
    this.errorText,
    this.valoreIniziale,
    this.obscureText = false,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.testoSopra != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.testoSopra!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: TextFormField(
            enabled: widget.enable,
            onTap: widget.onTap,
            controller: widget.controller,
            maxLines: widget.minLines,
            initialValue: widget.valoreIniziale,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText ? showPassword : false,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )
                  : null,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC2C2C2),
              ),
            ),
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }
}
