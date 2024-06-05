// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/utils.dart';

class RecipeListItem extends ConsumerWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String numeroLike;
  final String numeroCommenti;
  final String numeroCondivisioni;
  final String visualizzazioni;
  const RecipeListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.numeroLike,
    required this.numeroCommenti,
    required this.numeroCondivisioni,
    required this.visualizzazioni,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 2),
              child: Image.network(imageUrl,
                  width: MediaQuery.of(context).size.width * 0.09,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite),
                    spacer(10, 0),
                    Text(numeroLike),
                  ],
                ),
                spacer(0, 10),
                Row(
                  children: [
                    const Icon(Icons.comment),
                    spacer(10, 0),
                    Text(numeroCommenti),
                  ],
                ),
                spacer(0, 10),
                Row(
                  children: [
                    const Icon(Icons.share),
                    spacer(10, 0),
                    Text(numeroCondivisioni),
                  ],
                ),
                spacer(0, 10),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye),
                    spacer(10, 0),
                    Text(visualizzazioni),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
