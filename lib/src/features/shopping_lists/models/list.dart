import 'package:basket/src/shared/model_types.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'item.dart';

part 'list.g.dart';

@HiveType(typeId: shoppingListType)
class ShoppingList extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  HiveList<ShoppingListItem> items;

  ShoppingList({
    required this.name,
    this.description,
    required this.items,
  });

  List<ShoppingListItem> get complete => items.where((item) => item.checked).toList();
  List<ShoppingListItem> get incomplete => items.where((item) => !item.checked).toList();

  ShoppingList update({
    String? name,
    String? description,
  }) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    return this;
  }

  @override
  String toString() {
    return 'ShoppingList{name: $name, description: $description, items: ShoppingListItem[${items.length}]';
  }
}