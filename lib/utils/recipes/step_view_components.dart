import 'dart:typed_data';

import 'package:flutter/material.dart';

class StepViewComponents extends StatelessWidget {
  final String testo;
  final int stepIndex;
  final String? immagineUrl;
  final Uint8List? immagineUint8List;

  const StepViewComponents(
      {super.key,
      required this.stepIndex,
      this.immagineUrl,
      this.immagineUint8List,
      required this.testo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Step $stepIndex",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            testo,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        immagineUrl != null
            ? Image.network(
                immagineUrl!,
                width: 100,
                height: 100,
              )
            : immagineUint8List != null
                ? Image.memory(
                    immagineUint8List!,
                    width: 100,
                    height: 100,
                  )
                : const SizedBox(
                    width: 100,
                    height: 100,
                  ),
      ],
    );
  }
}
