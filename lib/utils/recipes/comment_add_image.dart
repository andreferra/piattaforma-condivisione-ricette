import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import '../constant.dart';

class AddImage extends ConsumerWidget {
  const AddImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeInteractionController =
        ref.watch(recipeInteractionProvider.notifier);

    final List<Uint8List> imageFile =
        ref.watch(recipeInteractionProvider).imageFile!;
    return Column(
      children: [
        const Text("Aggiungi fino a 4 immagini",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: () async {
                try {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    Uint8List file = await image.readAsBytes();
                    recipeInteractionController.onImageAdded(file);
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_a_photo),
              ),
            ),
            const SizedBox(width: defaultPadding),
            if (imageFile.isNotEmpty)
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFile.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Image.memory(imageFile[index], fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}
