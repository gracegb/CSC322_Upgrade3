import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class CustomMealsNotifier extends StateNotifier<List<Meal>> {
  CustomMealsNotifier() : super([]);

  void addMeal(Meal meal) {
    state = [...state, meal];
  }
}

final customMealsProvider = StateNotifierProvider<CustomMealsNotifier, List<Meal>>((ref) {
  return CustomMealsNotifier();
});
