import '../models/category_names.dart';
import '../models/grocery_item.dart';
import 'categories.dart';

final groceryItemsx = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[CategoryName.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[CategoryName.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[CategoryName.meat]!),
];
