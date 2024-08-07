import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/group_provider.dart';
import 'providers/item_provider.dart';
import 'providers/receipt_provider.dart';
import 'screens/create_group_screen.dart';
import 'screens/create_receipt_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_page.dart';
import 'screens/history_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ReceiptProvider()),
        ChangeNotifierProvider(create: (context) => GroupsProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          '/settings': (context) => const SettingsScreen(),
          '/create-group': (context) => const CreateGroupScreen(),
          '/groups': (context) => const GroupsScreen(),
          '/create-receipt': (context) => const CreateReceiptScreen(),
          '/history': (context) => const HistoryPage(),
        },
      ),
    );
  }
}
