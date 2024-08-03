import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/group_provider.dart';
import 'groupDetailsScreen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Future<void> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _fetchGroupsName();
  }

  Future<void> _fetchGroupsName() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      await groupsProvider.fetchGroupsName(user.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: _groupsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<GroupsProvider>(
              builder: (ctx, groupsProvider, child) {
                return ListView.builder(
                  itemCount: groupsProvider.groups.length,
                  itemBuilder: (ctx, index) {
                    final group = groupsProvider.groups[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: ListTile(
                        title: Text(
                          group.groupName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(group.description),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  GroupDetailsScreen(group: group),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
