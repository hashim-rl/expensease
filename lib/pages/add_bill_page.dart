import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/bill_service.dart';
import '../services/notification_service.dart';  // <- import NotificationService

class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final BillService billService = BillService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dueDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final billName = _nameController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final dueDate = selectedDate!;

      // Add bill to storage
      billService.addBill({
        'name': billName,
        'amount': amount,
        'dueDate': dueDate.toIso8601String(),
      });

      // Schedule notification 1 day before due date
      final reminderTime = dueDate.subtract(const Duration(days: 1));
      if (reminderTime.isAfter(DateTime.now())) {
        await NotificationService.scheduleNotification(
          id: dueDate.millisecondsSinceEpoch ~/ 1000,
          title: 'Upcoming Bill Due',
          body: 'Your bill "$billName" is due tomorrow!',
          scheduledDate: reminderTime,
        );
      }

      Get.back();
      Get.snackbar('Success', 'Bill added successfully', snackPosition: SnackPosition.BOTTOM);
    } else if (selectedDate == null) {
      Get.snackbar('Error', 'Please select a due date', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Bill Name', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter bill name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter amount';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDueDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
