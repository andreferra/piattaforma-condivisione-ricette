import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget buildLoadingIndicator() {
  return const Center(
    child: CupertinoActivityIndicator(),
  );
}

Widget spaceCenter(int flex) {
  return Expanded(
    flex: flex,
    child: const SizedBox(),
  );
}

Widget buildErrorIndicator(String message) {
  return Center(
    child: Text(message),
  );
}

Widget spacer(double width, double height) {
  return SizedBox(
    width: width,
    height: height,
  );
}

Widget formInserimento(String label, TextInputType type,
    Function(String) validator, Function(String) onSaved) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
    ),
    validator: (value) {
      return validator(value!);
    },
    onSaved: (value) {
      onSaved(value!);
    },
  );
}
