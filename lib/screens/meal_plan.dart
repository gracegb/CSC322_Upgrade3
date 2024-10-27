import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/meal_plan_provider.dart';
import 'package:meals/screens/meal_details.dart';

class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealPlan = ref.watch(mealPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(mealPlanProvider);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mealPlan.length,
        itemBuilder: (ctx, index) {
          final meal = mealPlan[index];
          return ListTile(
            title: Text(meal.title),
            subtitle: Text('${meal.duration} min • ${meal.complexity.name}'),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => MealDetailsScreen(meal: meal),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
