// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:model_repo/model_repo.dart';

class SfidaRicettaInfo extends StatefulWidget {
  final Sfidegame sfide;
  const SfidaRicettaInfo({super.key, required this.sfide});

  @override
  State<SfidaRicettaInfo> createState() => _SfidaRicettaInfoState();
}

class _SfidaRicettaInfoState extends State<SfidaRicettaInfo> {
  Sfidegame get sfide => widget.sfide;

  _formatIngredient(String ingredient) {
    String upperCase = ingredient.toString().substring(0, 1).toUpperCase() +
        ingredient.toString().substring(1);
    String rimuoviPuntiFinale = upperCase.replaceAll(".", "").trim();
    return "- $rimuoviPuntiFinale";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Alcune informazioni sulla sfida che dovrai affrontare:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (sfide.type == SfideType.ingredients &&
            sfide.ingredienti!.isNotEmpty)
          Column(
            children: [
              const Text(
                'Ecco la lista degli ingredienti che dovrai usare:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: sfide.ingredienti!.map((ingredient) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 40,
                      child: Text(
                        _formatIngredient(ingredient),
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        if (sfide.type == SfideType.image && sfide.urlImmagini!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Ecco le immagini che dovrai usare:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: sfide.urlImmagini!.map((immagine) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 40,
                      child: Image.network(
                        immagine,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
