import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/group_provider.dart';
import 'groupDetailsScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<void> _groupsFuture;
  String? _successMessage;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _fetchGroupsName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['successMessage'] != null) {
        setState(() {
          _successMessage = args['successMessage'];
        });
        args.remove('successMessage');
      }
    });
  }

  Future<void> _fetchGroupsName() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      await groupsProvider.fetchGroupsName(user.email);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final groupsProvider = Provider.of<GroupsProvider>(context);
    final user = authProvider.user;

    if (_successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_successMessage!)),
        );
        setState(() {
          _successMessage = null;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSplit'),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade200, Colors.blue.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user?.firstName} ${user?.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? 'user@example.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Create Group'),
              onTap: () {
                Navigator.pushNamed(context, '/create-group');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Create Receipt'),
              onTap: () {
                Navigator.pushNamed(context, '/create-receipt');
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
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authProvider.logout();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading groups: ${snapshot.error}'));
          } else if (groupsProvider.groups.isEmpty) {
            return const Center(child: Text('No groups available.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Group Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupsProvider.groups.length,
                      itemBuilder: (context, index) {
                        final group = groupsProvider.groups[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade800,
                              child:
                                  const Icon(Icons.group, color: Colors.white),
                            ),
                            title: Text(group.groupName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(group.description),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GroupDetailsScreen(group: group),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Create Group'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/create-group');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Create Receipt'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/create-receipt');
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }
}
