import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  final _confirmPasswordController = TextEditingController();

  bool _passwordsMatch = true;
  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  void _validateFields() {
    setState(() {
      _isFirstNameValid = _firstNameController.text.isNotEmpty;
      _isLastNameValid = _lastNameController.text.isNotEmpty;
      _isEmailValid = _isValidEmail(_emailController.text);
      _isPasswordValid = _passwordController.text.isNotEmpty;
      _isConfirmPasswordValid = _confirmPasswordController.text.isNotEmpty;
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
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
            colors: [Colors.purple.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lobster(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slide(),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      icon: Icons.person,
                      errorText:
                          !_isFirstNameValid ? 'This field is required' : null,
                    ),
                    CustomTextField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                      icon: Icons.person,
                      errorText:
                          !_isLastNameValid ? 'This field is required' : null,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email,
                      errorText: !_isEmailValid
                          ? 'Please enter a valid email address'
                          : null,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock,
                      obscureText: _isPasswordObscured,
                      errorText:
                          !_isPasswordValid ? 'This field is required' : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      icon: Icons.lock,
                      obscureText: _isConfirmPasswordObscured,
                      errorText: !_isConfirmPasswordValid
                          ? 'This field is required'
                          : !_passwordsMatch
                              ? 'Passwords do not match'
                              : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscured
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: 'Sign Up',
                      icon: Icons.person_add,
                      onPressed: () async {
                        _validateFields();
                        if (_isFirstNameValid &&
                            _isLastNameValid &&
                            _isEmailValid &&
                            _isPasswordValid &&
                            _isConfirmPasswordValid &&
                            _passwordsMatch) {
                          bool success = await authProvider.signUp(
                            _firstNameController.text,
                            _lastNameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (success) {
                            _showSnackBar('Sign up successful. Please log in.');
                            Navigator.pushReplacementNamed(context, '/login');
                          } else {
                            _showSnackBar(
                                'Error during sign up. Please try again.');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.blue),
                      ),
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
