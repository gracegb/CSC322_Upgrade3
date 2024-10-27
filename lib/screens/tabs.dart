import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meal_plan.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

import 'package:meals/models/meal.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // Close drawer
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    } else if (identifier == 'meal_plan') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const MealPlanScreen(), // Navigate to Meal Plan Screen
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MealSearchDelegate(availableMeals),
              );
            },
          ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class MealSearchDelegate extends SearchDelegate {
  final List<Meal> availableMeals;

  MealSearchDelegate(this.availableMeals);
  
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurple,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white70,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredMeals = availableMeals.where((meal) {
      return meal.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return MealsScreen(meals: filteredMeals);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredMeals = availableMeals.where((meal) {
      return meal.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredMeals.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(filteredMeals[index].title),
          onTap: () {
            query = filteredMeals[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}
