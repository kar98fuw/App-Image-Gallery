import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/image_post.dart';
import 'package:flutter_application_1/services/storage/services_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  Future<void> _showUploadDialog(StorageService storageService) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Image Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              storageService.uploadImage(
                _titleController.text,
                _descriptionController.text,
                _dateController.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text("Upload"),
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
            title: Text(storageService.isUploading ? "Uploading.." : "Image Gallery"),
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
