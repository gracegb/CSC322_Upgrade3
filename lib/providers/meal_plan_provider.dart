import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'dart:math';

import 'package:meals/providers/filters_provider.dart';

final mealPlanProvider = StateProvider<List<Meal>>((ref) {
  final availableMeals = ref.watch(filteredMealsProvider);
  return _generateMealPlan(availableMeals);
});

List<Meal> _generateMealPlan(List<Meal> availableMeals) {
  final random = Random();
  availableMeals.shuffle(random);
  return availableMeals.take(7).toList(); // Take seven meals for the week
}
