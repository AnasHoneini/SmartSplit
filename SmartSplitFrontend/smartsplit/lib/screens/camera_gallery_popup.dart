import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart' as path;
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
      File imageFile = File(pickedFile.path);
      // Upload the image to Firebase Storage
      // await _uploadToFirebase(imageFile);
    } else {
      print('No image selected.');
    }
  }

  // Future<void> _uploadToFirebase(File imageFile) async {
  //   try {
  //     String fileName = path.basename(imageFile.path);
  //     Reference storageRef =
  //         FirebaseStorage.instance.ref().child('receipts/$fileName');
  //     UploadTask uploadTask = storageRef.putFile(imageFile);

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();

  //     // Perform OCR on the uploaded image
  //     await _performOCR(imageFile);
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  // Future<void> _performOCR(File imageFile) async {
  //   final inputImage = InputImage.fromFilePath(imageFile.path);
  //   final textRecognizer = GoogleMlKit.vision.textDetector();
  //   final RecognisedText recognizedText =
  //       await textRecognizer.processImage(inputImage);

  //   // Extract and display the text
  //   String ocrText = recognizedText.text;
  //   print('OCR Text: $ocrText');

  //   // Dispose the text recognizer to release resources
  //   textRecognizer.close();

  //   // Show the result in a dialog or navigate to another screen
  //   if (mounted) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('OCR Result'),
  //           content: Text(ocrText),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

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
