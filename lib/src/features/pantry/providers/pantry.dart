
import 'package:basket/src/features/pantry/pantry.dart';
import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PantryProvider extends ValueNotifier<List<PantryItem>> {
  static late final PantryProvider instance;

  final Box<PantryItem> _box;

  PantryProvider._internal(this._box) : super(_box.values.toList()) {
    _box.watch().listen((event) {
      value = _box.values.toList();
    });
  }

  static Future<void> initialise() async {
    final Box<PantryItem> box = await Hive.openBox('pantry');
    instance = PantryProvider._internal(box);
  }

  void addShoppingListItem(ShoppingListItem item) {
    _box.add(PantryItem(shoppingListItem: item));
  }

  PantryItem? get(int id) {
    return _box.get(id);
  }

  bool isItemInPantry(ShoppingListItem item) {
    return _box.values.any((pantryItem) => pantryItem.shoppingListItem == item);
  }
}