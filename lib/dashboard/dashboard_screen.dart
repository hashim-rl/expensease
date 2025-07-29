import 'package:flutter/material.dart';
import '../services/bill_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BillService billService = BillService();
  List<Map<String, dynamic>> bills = [];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    bills = billService.getBills();
  }

  void _openBillForm({Map<String, dynamic>? bill, int? index}) {
    if (bill != null) {
      _nameController.text = bill['name'];
      _amountController.text = bill['amount'].toString();
      _selectedDate = DateTime.parse(bill['dueDate']);
      _editingIndex = index;
    } else {
      _nameController.clear();
      _amountController.clear();
      _selectedDate = null;
      _editingIndex = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: _formKey,
          child: Wrap(
            runSpacing: 15,
            children: [
              Text(
                _editingIndex == null ? 'Add Bill' : 'Edit Bill',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Bill Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter bill name' : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) =>
                value == null || double.tryParse(value) == null ? 'Enter valid amount' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No date selected'
                        : 'Due Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _selectedDate != null) {
                    final newBill = {
                      'name': _nameController.text,
                      'amount': double.parse(_amountController.text),
                      'dueDate': _selectedDate!.toIso8601String(),
                    };
                    if (_editingIndex == null) {
                      billService.addBill(newBill);
                    } else {
                      billService.updateBill(_editingIndex!, newBill);
                    }
                    setState(() => bills = billService.getBills());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(_editingIndex == null ? 'Add' : 'Update'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back, Explorer 🚀",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: bills.isEmpty
                  ? const Center(child: Text("No bills added yet"))
                  : ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return Dismissible(
                    key: Key(bill['name'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      setState(() {
                        billService.deleteBill(index);
                        bills = billService.getBills();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${bill['name']} deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () => _openBillForm(bill: bill, index: index),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(bill['name']),
                          subtitle: Text(
                              'Due: ${DateTime.parse(bill['dueDate']).toLocal().toString().split(' ')[0]}'),
                          trailing: Text('\$${bill['amount'].toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBillForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
