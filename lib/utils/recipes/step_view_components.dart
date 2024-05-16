import 'dart:typed_data';

import 'package:condivisionericette/utils/constant.dart';
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Step $stepIndex",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  children: [
                    immagineUrl != null
                        ? Image.network(
                            immagineUrl!,
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.2,
                          )
                        : immagineUint8List != null
                            ? Image.memory(
                                immagineUint8List!,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              )
                            : const SizedBox(
                                width: 100,
                                height: 100,
                              ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      testo,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
