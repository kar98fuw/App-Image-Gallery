import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/storage/services_storage.dart';
import 'package:provider/provider.dart';

class ImagePost extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String date;

  const ImagePost({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) => Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón de eliminación
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => storageService.deleteImage(imageUrl),
                icon: const Icon(Icons.delete),
              ),
            ),
            // Imagen
            Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                } else {
                  return child;
                }
              },
            ),
            // Título, Descripción y Fecha
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: $title", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Description: $description"),
                  Text("Date: $date"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
