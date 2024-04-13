import 'package:flutter/material.dart';


Widget buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    ),
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
    Function(String) validator, TextEditingController controller) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
    ),
    validator: (value) {
      return validator(value!);
    },
    controller: controller,
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white), // Cambia il colore del testo
    ),
    backgroundColor: Colors.red, // Cambia il colore di sfondo
    duration: Duration(seconds: 3), // Cambia la durata di visualizzazione
    behavior: SnackBarBehavior.floating, // Fa apparire la snackbar sopra gli altri widget
    shape: RoundedRectangleBorder( // Aggiunge bordi arrotondati
      borderRadius: BorderRadius.circular(25.0),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
