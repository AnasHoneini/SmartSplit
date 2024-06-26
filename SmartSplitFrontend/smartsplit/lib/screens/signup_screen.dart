// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:path/path.dart' as path;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _profilePicture;
  String? _profilePictureUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
        String fileName = path.basename(pickedFile.path);
        _profilePictureUrl = 'http://example.com/${Uri.encodeFull(fileName)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profilePicture != null
                            ? FileImage(_profilePicture!)
                            : null,
                        child: _profilePicture == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey[800],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                        controller: _firstNameController,
                        hintText: 'First Name'),
                    CustomTextField(
                        controller: _lastNameController, hintText: 'Last Name'),
                    CustomTextField(
                        controller: _emailController, hintText: 'Email'),
                    CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        await authProvider.signUp(
                          context,
                          _firstNameController.text,
                          _lastNameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _profilePictureUrl,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
