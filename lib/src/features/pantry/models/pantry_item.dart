
import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:basket/src/shared/model_types.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'pantry_item.g.dart';

@HiveType(typeId: pantryItemType)
class PantryItem {
  @HiveField(0)
  final ShoppingListItem shoppingListItem;

  PantryItem({
    required this.shoppingListItem,
  });
}