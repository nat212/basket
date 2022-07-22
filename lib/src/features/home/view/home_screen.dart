import 'package:basket/src/features/pantry/pantry.dart';
import 'package:basket/src/features/shopping_lists/models/models.dart';
import 'package:basket/src/features/shopping_lists/providers/providers.dart';
import 'package:basket/src/shared/providers/settings.dart';
import 'package:basket/src/shared/providers/theme.dart';
import 'package:basket/src/shared/views/adaptive_padding.dart';
import 'package:basket/src/shared/views/spaced_column.dart';
import 'package:basket/src/shared/views/spaced_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ShoppingList _selectedList = ShoppingListProvider.instance.value.first;
  final TextEditingController _autocompleteController = TextEditingController();
  final FocusNode _autocompleteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: AdaptivePadding(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ValueListenableBuilder<List<ShoppingList>>(
        valueListenable: ShoppingListProvider.instance,
        builder: (context, lists, _) {
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
              ),
              child: SpacedColumn(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButtonFormField<ShoppingList>(
                    value: _selectedList,
                    items: [
                      for (final list in lists)
                        DropdownMenuItem(
                          value: list,
                          child: Text(list.name),
                        ),
                      DropdownMenuItem(
                        child: const SpacedRow(
                          spacing: 8,
                          children: [
                            Icon(Icons.add),
                            Text('Add list'),
                          ],
                        ),
                        onTap: () {
                          GoRouter.of(context).push('/lists/add');
                        },
                      )
                    ],
                    onChanged: (ShoppingList? list) {
                      setState(() {
                        _selectedList = list ?? _selectedList;
                      });
                    },
                  ),
                  RawAutocomplete<ShoppingListItem>(
                    textEditingController: _autocompleteController,
                    focusNode: _autocompleteFocusNode,
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                              elevation: 4.0,
                              shape: ThemeProvider.of(context).shapeMedium,
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: constraints.maxWidth,
                                ),
                                child: ListView.builder(
                                  itemCount: options.length,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option.name),
                                      onTap: () {
                                        onSelected(option);
                                      },
                                    );
                                  },
                                ),
                              )));
                    },
                    fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) =>
                        TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (_) => onFieldSubmitted(),
                      decoration: const InputDecoration(
                        labelText: 'Add Item',
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      final items = PantryProvider.instance.value.where(
                        (element) => element
                            .shoppingListItem.searchableRepresentation
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()),
                      );
                      return [
                        ...items.map((item) => item.shoppingListItem),
                        if (textEditingValue.text.isNotEmpty && items.isEmpty)
                          ShoppingListItem(
                            name: textEditingValue.text.trim(),
                          ),
                      ];
                    },
                    displayStringForOption: (ShoppingListItem option) =>
                        option.name,
                    onSelected: (ShoppingListItem? item) {
                      _autocompleteController.clear();
                      _autocompleteFocusNode.unfocus();
                      if (item != null) {
                        if (_selectedList.items.contains(item)) {
                          return;
                        }
                        ShoppingListProvider.instance
                            .addShoppingListItem(_selectedList, item);
                        if (SettingsProvider.autoAddToPantry &&
                            !PantryProvider.instance.isItemInPantry(item)) {
                          PantryProvider.instance.addShoppingListItem(item);
                        }
                      }
                    },
                  ),
                  Expanded(
                    child: _body(),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildItemList(_selectedList.incomplete),
          if (_selectedList.complete.isNotEmpty &&
              _selectedList.incomplete.isNotEmpty)
            const Divider(),
          _buildItemList(_selectedList.complete),
        ],
      ),
    );
  }

  Widget _buildItemList(List<ShoppingListItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Checkbox(
            value: item.checked,
            onChanged: (bool? value) {
              item.checked = value ?? false;
              item.save();
            },
          ),
          title: Text(item.name),
          subtitle: item.description != null ? Text(item.description!) : null,
          onTap: () {
            item.checked = !item.checked;
            item.save();
          },
        );
      },
    );
  }
}
