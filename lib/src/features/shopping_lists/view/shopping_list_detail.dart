import 'package:basket/src/shared/views/spaced_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  const ShoppingListDetailScreen({Key? key, required this.shoppingList})
      : super(key: key);

  final ShoppingList shoppingList;

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.name),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            GoRouter.of(context).push(
              '/lists/${widget.shoppingList.key}/items/add',
            );
          },
          label: const Text('Add Item'),
          icon: const Icon(Icons.add)),
    );
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: ValueListenableBuilder<List<ShoppingListItem>>(
          valueListenable: ShoppingListItemProvider(widget.shoppingList),
          builder: (context, items, _) => ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                leading: Checkbox(
                  value: item.checked,
                  onChanged: (value) {
                    item.checked = (value ?? false);
                    item.save();
                  },
                ),
                subtitle:
                    item.description == null ? null : Text(item.description!),
                onTap: () {
                  item.checked = !item.checked;
                  item.save();
                },
                trailing: PopupMenuButton(
                  child: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const SpacedRow(
                        spacing: 8,
                        children: [
                          Text('Edit'),
                          Icon(Icons.edit),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context).push(
                            '/lists/${widget.shoppingList.key}/items/${item.key}');
                      },
                    ),
                    PopupMenuItem(
                      child: const SpacedRow(
                        spacing: 8,
                        children: [
                          Text('Delete'),
                          Icon(Icons.delete),
                        ],
                      ),
                      onTap: () {
                        _deleteItem(item);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Future<void> _deleteItem(ShoppingListItem item) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Item'),
              content: Text('Are you sure you wish to delete ${item.name}?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete')),
              ],
            ));
    if (result ?? false) {
      item.delete();
    }
  }
}
