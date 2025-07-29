import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  String _currency = 'USD';
  String _language = 'English';

  final List<String> currencies = ['USD', 'PKR', 'EUR', 'GBP', 'INR'];
  final List<String> languages = ['English', 'Urdu', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) {
              setState(() {
                _darkMode = val;
                // TODO: Implement dark mode toggle in app theme
                Get.snackbar('Theme Changed',
                    val ? 'Dark mode enabled' : 'Light mode enabled',
                    snackPosition: SnackPosition.BOTTOM);
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: _currency,
              items: currencies
                  .map((cur) => DropdownMenuItem(
                value: cur,
                child: Text(cur),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  if (val != null) _currency = val;
                  // TODO: Persist currency choice
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              items: languages
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  if (val != null) _language = val;
                  // TODO: Implement localization change
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Delete Account'),
            leading: const Icon(Icons.delete, color: Colors.red),
            onTap: () {
              // TODO: Confirm and delete account logic
              Get.defaultDialog(
                title: 'Confirm Delete',
                middleText: 'Are you sure you want to delete your account?',
                textConfirm: 'Yes, Delete',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  Get.snackbar('Deleted', 'Account deleted successfully.',
                      snackPosition: SnackPosition.BOTTOM);
                  // TODO: Perform deletion
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
