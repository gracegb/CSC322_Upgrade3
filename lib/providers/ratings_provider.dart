// ratings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class RatingsNotifier extends StateNotifier<Map<String, double>> {
  RatingsNotifier() : super({});

  void rateMeal(String mealId, double rating) {
    state = {...state, mealId: rating};
  }

  double getRating(String mealId) {
    return state[mealId] ?? 0.0;
  }
}

final ratingsProvider = StateNotifierProvider<RatingsNotifier, Map<String, double>>((ref) {
  return RatingsNotifier();
});
