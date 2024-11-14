import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/image_post.dart';
import 'package:flutter_application_1/services/storage/services_storage.dart';
import 'package:provider/provider.dart';
import 'about_section.dart'; // Importa el archivo de AboutSection

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedType = 'Image'; // Nuevo campo para el tipo de contenido

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  Future<void> _showUploadDialog(StorageService storageService) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector de tipo de contenido
            DropdownButton<String>(
              value: _selectedType,
              items: <String>['Image', 'Audio'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Date"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_selectedType == 'Image') {
                storageService.uploadImage(
                  _titleController.text,
                  _descriptionController.text,
                  _dateController.text,
                );
              } else {
                storageService.uploadImage(
                  _titleController.text,
                  _descriptionController.text,
                  _dateController.text,
                );
              }
              Navigator.of(context).pop();
            },
            child: Text("Upload $_selectedType"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final List<Map<String, String>> imageData = storageService.imageData;

        return Scaffold(
          appBar: AppBar(
            title: Text(storageService.isUploading ? "Uploading.." : "Media Gallery"),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AboutSection(
                        photoUrl: 'https://plataformavirtual.itla.edu.do/pluginfile.php/414569/user/icon/fordson/f1?rev=90269350',
                        firstName: 'Misael',
                        lastName: 'Encarnacion Javier',
                        badgeNumber: '2022-1994',
                        reflection: '“El servicio a la comunidad es el deber más noble de un oficial.”',
                      ),
                    ),
                  );
                },
                tooltip: "Acerca de",
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showUploadDialog(storageService),
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: imageData.length,
            itemBuilder: (context, index) {
              final data = imageData[index];
              return ImagePost(
                imageUrl: data['url']!,
                title: data['title']!,
                description: data['description']!,
                date: data['date']!,
              );
            },
          ),
        );
      },
    );
  }
}
