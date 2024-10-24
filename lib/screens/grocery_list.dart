import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class GroceryList extends StatefulWidget {
  final Meal meal;

  const GroceryList({super.key, required this.meal});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int servingCount = 1;
  List<bool> _checkedItems = [];  // List to keep track of checked states

  @override
  void initState() {
    super.initState();
    // Initialize the checkedItems list to be false for all ingredients
    _checkedItems = List<bool>.filled(widget.meal.ingredients.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grocery List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Serving Count: ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // Make text white
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    style: const TextStyle(color: Colors.white), // Make text white in TextField
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        servingCount = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.meal.ingredients.length,
              itemBuilder: (ctx, index) {
                final ingredient = widget.meal.ingredients[index];

                return ListTile(
                  leading: Checkbox(
                    value: _checkedItems[index], // Bind the checkbox to the checked state
                    onChanged: (val) {
                      setState(() {
                        _checkedItems[index] = val ?? false; // Toggle the checked state
                      });
                    },
                  ),
                  title: Text(
                    '$ingredient * $servingCount',
                    style: const TextStyle(color: Colors.white), // Make ingredients text white
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
