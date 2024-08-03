import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Welcome to SmartSplit!',
              style: GoogleFonts.lobster(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 500.ms).then().slide(),
            const SizedBox(height: 20.0),
            const Text(
              'Manage your money effortlessly with our application.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 700.ms),
            const Spacer(),
            CustomButton(
              text: 'Login',
              icon: Icons.login,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Sign Up',
              icon: Icons.person_add,
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
