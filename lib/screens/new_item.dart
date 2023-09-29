import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:userinput/models/grocery_item.dart';
import '../data/categories.dart';
import '../models/category_names.dart';

class NewItem extends StatefulWidget {
  NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  var _initialQuantity = 1;
  var _selectedCategory = categories[CategoryName.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https('grocery-list-d1823-default-rtdb.firebaseio.com',
          'grocery-list.json');
      final rep = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _initialQuantity,
            'category': _selectedCategory.name,
          },
        ),
      );

      print(rep.body);
      print(rep.statusCode);

      final Map<String, dynamic> resData = json.decode(rep.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _initialQuantity,
        category: _selectedCategory,
      ));

      // Navigator.of(context).pop(GroceryItem(
      //   id: DateTime.now().toString(),
      //   category: _selectedCategory,
      //   quantity: _initialQuantity,
      //   name: _enteredName,
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add a new item')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 2 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredName = newValue!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _initialQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length > 8 ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be between 1 and 50 characters.';
                          }

                          return null;
                        },
                        onSaved: (newValue) {
                          _initialQuantity = int.parse(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(children: [
                                  Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color),
                                  const SizedBox(width: 6),
                                  Text(category.value.name),
                                ]),
                              )
                          ],
                          onChanged: (value) {
                            // need setState here, to rebuild, this onChanged, not onSaved
                            setState(() {
                              _selectedCategory = value!;
                            });
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Item'),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
