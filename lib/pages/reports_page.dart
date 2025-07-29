import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  // Sample data for demo
  final List<Map<String, dynamic>> reportData = const [
    {'category': 'Rent', 'amount': 1200.0},
    {'category': 'Electricity', 'amount': 150.0},
    {'category': 'Water', 'amount': 50.0},
    {'category': 'Internet', 'amount': 80.0},
    {'category': 'Meals', 'amount': 300.0},
  ];

  @override
  Widget build(BuildContext context) {
    double total = reportData.fold(0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Total Expenses: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reportData.length,
                itemBuilder: (context, index) {
                  final item = reportData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['category']),
                      trailing: Text('\$${item['amount'].toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
