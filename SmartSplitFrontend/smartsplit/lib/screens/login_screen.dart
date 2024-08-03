import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isPasswordObscured = true;

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _validateFields() {
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty &&
          _isValidEmail(_emailController.text);
      _isPasswordValid = _passwordController.text.isNotEmpty;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final logoutMessage = args != null ? args['logoutMessage'] : null;

    if (logoutMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(logoutMessage);
      });
      args?.remove('logoutMessage');
    }
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
                      'Login',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lobster(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slide(),
                    const SizedBox(height: 20.0),
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
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: 'Login',
                      icon: Icons.login,
                      onPressed: () async {
                        _validateFields();
                        if (_isEmailValid && _isPasswordValid) {
                          try {
                            bool success = await authProvider.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/main',
                                arguments: {
                                  'successMessage': 'Login successful!'
                                },
                              );
                            } else {
                              _showSnackBar('Email or password is incorrect');
                            }
                          } catch (e) {
                            _showSnackBar('Failed to login: $e');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
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
