import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:userinput/data/categories.dart';
import '../models/grocery_item.dart';
import 'package:http/http.dart' as http;
import './new_item.dart';

class YourGroceries extends StatefulWidget {
  const YourGroceries({super.key});

  @override
  State<YourGroceries> createState() => _YourGroceriesState();
}

class _YourGroceriesState extends State<YourGroceries> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;

  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'grocery-list-d1823-default-rtdb.firebaseio.com', 'grocery-list.json');

    try {
      final response = await http.get(url);

      print(response.statusCode);
      if (response.statusCode >= 400) {
        _error = 'Failed to fetch data. Please try again later.';
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.name == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Exception, ${e.toString()}";
      });
    }
  }

  void _addItem() async {
    var newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(int item) async {
    GroceryItem groc = _groceryItems[item];

    setState(() {
      _groceryItems.remove(groc);
    });
    // send HTTP request to delete.
    final url = Uri.https('grocery-list-d1823-default-rtdb.firebaseio.com',
        'grocery-list/${groc.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(item, groc);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _error == null
          ? !_isLoading
              ? _groceryItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (context, index) {
                        var item = _groceryItems[index];
                        return Dismissible(
                          onDismissed: (direction) {
                            _removeItem(index);
                          },
                          key: ValueKey(_groceryItems[index].id),
                          child: ListTile(
                            leading: Container(
                              width: 24,
                              height: 24,
                              color: item.category.color,
                            ),
                            title: Text(item.name),
                            trailing: Text(item.quantity.toString()),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("no list yet"))
              : const Center(child: CircularProgressIndicator())
          : Center(child: Text(_error!)),
    );
  }
}
