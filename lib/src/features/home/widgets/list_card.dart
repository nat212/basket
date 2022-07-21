import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:basket/src/shared/providers/theme.dart';
import 'package:basket/src/shared/views/spaced_column.dart';
import 'package:basket/src/shared/views/spaced_row.dart';
import 'package:flutter/material.dart';

class ShoppingListCard extends StatelessWidget {
  const ShoppingListCard({Key? key, required this.shoppingList, this.onTap})
      : super(key: key);

  final ShoppingList shoppingList;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: ThemeProvider.of(context).mediumBorderRadius,
      ),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _cardContents(context),
        ),
      ),
    );
  }

  Widget _cardContents(BuildContext context) {
    return Center(
      child: SpacedColumn(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(shoppingList.name, style: Theme.of(context).textTheme.headline6),
          if (shoppingList.description?.isNotEmpty ?? false)
            Text(shoppingList.description!),
          SpacedRow(
            spacing: 4,
            children: [
              Text('${shoppingList.items.length} items'),
              if (shoppingList.items.isNotEmpty)
                Text('(${shoppingList.complete.length} complete)'),
            ],
          )
        ],
      ),
    );
  }
}
