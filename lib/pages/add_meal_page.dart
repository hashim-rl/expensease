import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/meal_service.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final MealService mealService = MealService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> users = ['Alice', 'Bob', 'Charlie', 'You']; // Sample users
  late Map<String, bool> selectedUsers;

  @override
  void initState() {
    super.initState();
    selectedUsers = {for (var user in users) user: false};
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final selected = selectedUsers.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selected.isEmpty) {
      Get.snackbar(
        'No Participants',
        'Please select at least one participant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    final newMeal = {
      'description': _descriptionController.text.trim(),
      'amount': double.parse(_amountController.text.trim()),
      'participants': selected,
      'date': DateTime.now().toIso8601String(),
    };

    mealService.addMeal(newMeal);
    Get.back();
    Get.snackbar(
      'Meal Added',
      'Your meal was added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Meal Description',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Total Cost',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter an amount';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Participants',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ...users.map(
                    (user) => CheckboxListTile(
                  title: Text(user),
                  value: selectedUsers[user],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedUsers[user] = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Add Meal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
