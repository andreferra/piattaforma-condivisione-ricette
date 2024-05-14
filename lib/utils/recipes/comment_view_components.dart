import 'package:condivisionericette/model/Comment.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget {
  final Comment commento;

  const CommentCard(this.commento, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    //TODO: Add navigation to user profile
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(commento.urlUtente!),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(commento.nicknameUtente!),
                    Text(commento.dataCreazione!
                        .toDate()
                        .toString()
                        .substring(0, 10)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text("Commento:"),
            const SizedBox(height: 8),
            if (commento.commento!.length > 200)
              Text(
                commento.commento!.substring(0, 200),
                textAlign: TextAlign.center,
                softWrap: true,
              )
            else
              Text(
                commento.commento!,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            Text(
              commento.commento!,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 8),
            //TODO: Add recipes photo
            if (commento.numeroStelle != 0)
              Row(
                children: [
                  for (var i = 0; i < commento.numeroStelle!; i++)
                    const Icon(Icons.star, color: Colors.yellow, size: 20),
                ],
              )
            // aggiungere reply button
          ],
        ),
      ),
    );
  }
}
