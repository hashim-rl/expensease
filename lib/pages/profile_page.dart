import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = AuthService().currentUser; // Use currentUser getter

  Future<void> _handleLogout() async {
    await AuthService().signOut(); // Await sign out
    if (!mounted) return; // Check if widget is still in tree
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Name: ${user?.displayName ?? 'N/A'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const Center(
              child: Text(
                'TeamSync Lite',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
