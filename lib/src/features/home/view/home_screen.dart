import 'package:basket/src/features/shopping_lists/models/models.dart';
import 'package:basket/src/features/shopping_lists/providers/providers.dart';
import 'package:basket/src/shared/extensions.dart';
import 'package:basket/src/shared/views/adaptive_padding.dart';
import 'package:basket/src/shared/views/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/list_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _addList(context);
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add)),
      body: AdaptivePadding(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ValueListenableBuilder<List<ShoppingList>>(
        valueListenable: ShoppingListProvider.instance,
        builder: (context, lists, _) {
          return SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.isMobile) {
                return SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final shoppingList in lists)
                        ShoppingListCard(
                          shoppingList: shoppingList,
                          onTap: () {
                            GoRouter.of(context)
                                .push('/lists/${shoppingList.key}');
                          },
                        ),
                    ]);
              } else {
                return GridView.count(crossAxisCount: 3, children: [
                  for (final shoppingList in lists)
                    ShoppingListCard(
                      shoppingList: shoppingList,
                      onTap: () {
                        GoRouter.of(context).push('/lists/${shoppingList.key}');
                      },
                    ),
                ]);
              }
            }),
          );
        });
  }

  void _addList(BuildContext context) {
    GoRouter.of(context).push('/lists/add');
  }
}
