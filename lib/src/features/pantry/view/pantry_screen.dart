import 'package:basket/src/features/pantry/pantry.dart';
import 'package:basket/src/shared/views/adaptive_padding.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({Key? key}) : super(key: key);

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
      ),
      body: _bodyWrapper(),
    );
  }

  Widget _bodyWrapper() {
    return ValueListenableBuilder<List<PantryItem>>(
        valueListenable: PantryProvider.instance,
        builder: (context, value, child) => _body(value));
  }

  Widget _body(List<PantryItem> items) {
    return AdaptivePadding(
        child: SingleChildScrollView(
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = items[index];
          final shoppingListItem = item.shoppingListItem;
          return ListTile(
            title: Text(shoppingListItem.name),
            subtitle: shoppingListItem.description != null
                ? Text(shoppingListItem.description!)
                : null,
          );
        },
      ),
    ));
  }
}
