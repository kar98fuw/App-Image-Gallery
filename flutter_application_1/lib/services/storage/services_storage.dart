import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;

  // List of image data with title, description, and date
  List<Map<String, String>> _imageData = [];

  bool _isLoading = false;
  bool _isUploading = false;

  List<Map<String, String>> get imageData => _imageData;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  Future<void> fetchImages() async {
    _isLoading = true;

    final ListResult result = await firebaseStorage.ref('uploaded_images/').listAll();
    final urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

    // Clear previous data and update with fetched URLs
    _imageData = urls.map((url) => {
      'url': url,
      'title': 'Sample Title', // Default placeholder
      'description': 'Sample Description', // Default placeholder
      'date': DateTime.now().toString() // Placeholder for date
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      _imageData.removeWhere((data) => data['url'] == imageUrl);
      final String path = extractPathFromUrl(imageUrl);
      await firebaseStorage.ref(path).delete();
    } catch (e) {
      print("Error deleting image: $e");
    }
    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String encodedPath = uri.pathSegments.last;
    return Uri.decodeComponent(encodedPath);
  }

  Future<void> uploadImage(String title, String description, String date) async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    try {
      String filePath = 'uploaded_images/${DateTime.now()}.png';
      await firebaseStorage.ref(filePath).putFile(file);
      String downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();

      _imageData.add({
        'url': downloadUrl,
        'title': title,
        'description': description,
        'date': date
      });
      notifyListeners();
    } catch (e) {
      print("Error uploading..$e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
