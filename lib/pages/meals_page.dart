import 'package:flutter/material.dart';
import '../services/meal_service.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  final MealService mealService = MealService();
  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();
    meals = mealService.getMeals();
  }

  void deleteMeal(int index) {
    setState(() {
      meals.removeAt(index);
    });
    // Optionally remove from service if persistence is required:
    // mealService.deleteMeal(mealId); // if you have IDs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: meals.isEmpty
          ? const Center(child: Text('No meals added yet'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          final date = DateTime.parse(meal['date']).toLocal();
          final formattedDate =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => deleteMeal(index),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(meal['description']),
                subtitle: Text(
                    'Participants: ${meal['participants'].join(', ')}\nDate: $formattedDate'),
                trailing:
                Text('\$${meal['amount'].toStringAsFixed(2)}'),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
