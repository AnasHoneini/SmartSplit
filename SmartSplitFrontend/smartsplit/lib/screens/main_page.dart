import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartsplit/screens/groups_screen.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../screens/receipts_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSplit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${user?.firstName} ${user?.lastName}'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     user?.profilePicture != null
              //         ? user!.profilePicture
              //         : 'https://via.placeholder.com/150',
              //   ),
              // ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.receipt),
            //   title: const Text('Create Receipt'),
            //   onTap: () {
            //     Navigator.pushNamed(context, '/create-receipt');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Create Group'),
              onTap: () {
                Navigator.pushNamed(context, '/create-group');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture Receipt'),
              onTap: () {
                Navigator.pushNamed(context, '/camera-gallery-popup');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Toggle Dark Mode'),
              onTap: () {
                // TODO: Add functionality to toggle dark mode
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Recent Group Activity'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text('Recent Receipts'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReceiptsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera-gallery-popup');
        },
        child: const Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.history),
          //   label: 'History',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/payment-history');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
