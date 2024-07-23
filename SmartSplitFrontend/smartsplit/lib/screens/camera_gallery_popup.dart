import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraGalleryPopup extends StatefulWidget {
  const CameraGalleryPopup({super.key});

  @override
  CameraGalleryPopupState createState() => CameraGalleryPopupState();
}

class CameraGalleryPopupState extends State<CameraGalleryPopup> {
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // ignore: unused_local_variable
      File imageFile = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture or Upload Receipt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              child: const Text('Capture with Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Upload from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
