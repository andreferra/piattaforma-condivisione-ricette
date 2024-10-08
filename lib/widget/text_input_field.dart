// Flutter imports:
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String hintText;
  final String? autofillHints;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? errorText;
  final String? valoreIniziale;
  final bool? enable;
  final String? labelText;
  final bool obscureText;
  final void Function()? onTap;
  final void Function()? onSubmitted;
  final int? minLines;
  final FocusNode? focusNode;
  final String? testoSopra;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final int? maxLength;
  final bool hasMaxLenght;
  const TextInputField({
    super.key,
    this.controller,
    this.autofillHints,
    this.enable = true,
    this.minLines,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.testoSopra,
    this.prefixIcon,
    this.labelText,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.onTap,
    required this.onChanged,
    this.errorText,
    this.focusNode,
    this.valoreIniziale,
    this.obscureText = false,
    this.maxLength,
    this.hasMaxLenght = false,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  TextEditingController controllerTest = TextEditingController();
  bool showPassword = true;

  @override
  void initState() {
    if (widget.valoreIniziale != null) {
      controllerTest.text = widget.valoreIniziale!;
    }
    super.initState();
  }

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
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: TextFormField(
            focusNode: widget.focusNode,
            autofillHints:
                widget.autofillHints != null ? [widget.autofillHints!] : null,
            maxLength: widget.hasMaxLenght ? widget.maxLength : null,
            enabled: widget.enable,
            onTap: widget.onTap,
            controller: widget.controller ?? controllerTest,
            maxLines: widget.obscureText ? 1 : widget.minLines,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText ? showPassword : false,
            onFieldSubmitted: (p0) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!();
                widget.focusNode!.requestFocus();
              }
            },
            decoration: InputDecoration(
              counterText: widget.hasMaxLenght
                  ? '${controllerTest.text.length}/${widget.maxLength}'
                  : null,
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
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
