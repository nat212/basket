import 'package:basket/src/features/shopping_lists/models/models.dart';
import 'package:flutter/material.dart';

class ShoppingListItemProvider extends ValueNotifier<List<ShoppingListItem>> {
  final ShoppingList list;
  ShoppingListItemProvider(this.list): super(list.items.toList()) {
    list.items.box.watch().listen((event) {
      value = list.items.toList();
    });
  }
}