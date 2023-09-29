import 'package:flutter/material.dart';

import '../models/category_names.dart';
import '../models/category.dart';

var categories = {
  CategoryName.vegetables: Category(
    'Vegie and Fruit',
    Color.fromARGB(255, 0, 255, 128),
  ),
  CategoryName.fruit: Category(
    'Bulk',
    Color.fromARGB(255, 145, 255, 0),
  ),
  CategoryName.meat: Category(
    'Raw meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  CategoryName.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  CategoryName.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  CategoryName.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  CategoryName.spices: Category(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  CategoryName.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  CategoryName.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  CategoryName.other: Category(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};
