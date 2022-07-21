import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListProvider extends ValueNotifier<List<ShoppingList>> {
  static late final ShoppingListProvider instance;

  final Box<ShoppingList> _box;
  final Box<ShoppingListItem> _itemBox;

  ShoppingListProvider._internal(this._box, this._itemBox)
      : super(_box.values.toList()) {
    _box.watch().listen((event) {
      value = _box.values.toList();
    });
    _itemBox.watch().listen((event) {
      value = _box.values.toList();
    });
  }

  static Future<void> initialise() async {
    final Box<ShoppingList> box = await Hive.openBox('shoppingLists');
    final Box<ShoppingListItem> itemBox =
        await Hive.openBox('shoppingListItems');
    instance = ShoppingListProvider._internal(box, itemBox);
  }

  void addShoppingList(String name, [String? description]) {
    _box.add(ShoppingList(
        name: name,
        description: description,
        items: HiveList<ShoppingListItem>(_itemBox)));
  }

  void addShoppingListItem(ShoppingList list, ShoppingListItem item) {
    _itemBox.add(item);
    list.items.add(item);
  }

  ShoppingList? get(int id) {
    return _box.get(id);
  }

  ShoppingListItem? getItem(int id) {
    return _itemBox.get(id);
  }
}
