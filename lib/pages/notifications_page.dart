import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // Sample notifications data
  final List<Map<String, String>> notifications = const [
    {
      'title': 'Payment Reminder',
      'body': 'Rent is due in 3 days.',
      'time': '2h ago',
    },
    {
      'title': 'Bill Added',
      'body': 'Electricity bill added by Alice.',
      'time': '1d ago',
    },
    {
      'title': 'Payment Confirmed',
      'body': 'Bob paid his share for groceries.',
      'time': '3d ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notification['title']!),
            subtitle: Text(notification['body']!),
            trailing: Text(notification['time']!),
          );
        },
      ),
    );
  }
}
