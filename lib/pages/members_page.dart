import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  // Sample members data (replace with real data later)
  final List<Map<String, dynamic>> members = const [
    {'name': 'Alice', 'balance': 120.50, 'role': 'Admin'},
    {'name': 'Bob', 'balance': -50.75, 'role': 'Member'},
    {'name': 'Charlie', 'balance': 0.0, 'role': 'Member'},
    {'name': 'You', 'balance': 30.25, 'role': 'Admin'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final balance = member['balance'] as double;
          final balanceColor = balance >= 0 ? Colors.green : Colors.red;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade200,
                child: Text(
                  member['name'][0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(member['name']),
              subtitle: Text('Role: ${member['role']}'),
              trailing: Text(
                '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: balanceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
