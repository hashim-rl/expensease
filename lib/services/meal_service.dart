import 'package:get_storage/get_storage.dart';

class MealService {
  final GetStorage _box = GetStorage();
  final String _key = 'meals';

  List<Map<String, dynamic>> getMeals() {
    final data = _box.read<List<dynamic>>(_key);
    if (data == null) return [];
    // Safely cast each element to Map<String, dynamic>
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  void addMeal(Map<String, dynamic> meal) {
    final meals = getMeals();
    meals.add(meal);
    _box.write(_key, meals);
  }

  void clearMeals() {
    _box.remove(_key);
  }

  void deleteMeal(int index) {
    final meals = getMeals();
    if (index >= 0 && index < meals.length) {
      meals.removeAt(index);
      _box.write(_key, meals);
    }
  }
}
