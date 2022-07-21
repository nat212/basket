import 'package:basket/src/shared/model_types.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'item.g.dart';

@HiveType(typeId: shoppingListItemType)
class ShoppingListItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2, defaultValue: 1)
  int quantity;

  @HiveField(3, defaultValue: false)
  bool checked;

  ShoppingListItem({
    required this.name,
    this.description,
    this.quantity = 1,
    this.checked = false,
  });

  ShoppingListItem copyWith({
    String? name,
    String? description,
    int? quantity,
    bool? checked,
  }) {
    return ShoppingListItem(
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      checked: checked ?? this.checked,
    );
  }

  ShoppingListItem update({
    String? name,
    String? description,
    int? quantity,
    bool? checked,
  }) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.quantity = quantity ?? this.quantity;
    this.checked = checked ?? this.checked;
    return this;
  }
}