import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingSheet extends StatelessWidget {
  const LoadingSheet._({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
        ),
        context: context,
        builder: (_) {
          return const LoadingSheet._();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blueGrey.shade700, size: 80),
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String error;
  const ErrorDialog._(this.error, {Key? key}) : super(key: key);

  static Future<void> show(
    BuildContext context,
    String errorMessage,
  ) {
    return showDialog(
      context: context,
      builder: (_) => ErrorDialog._(errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(error),
      actions: [
        TextButton(
          child: const Text('Okay'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
