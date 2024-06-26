import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
      child: MaterialApp(
        title: 'SmartSplit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/signup': (ctx) => const SignUpScreen(),
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}
