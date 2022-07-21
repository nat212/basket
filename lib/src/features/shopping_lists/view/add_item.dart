import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:basket/src/shared/views/adaptive_padding.dart';
import 'package:basket/src/shared/views/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key, this.initialItem, required this.list})
      : super(key: key);

  final ShoppingListItem? initialItem;
  final ShoppingList list;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _ItemModel {
  String? name;
  String? description;
  int? quantity;

  _ItemModel({
    this.name,
    this.description,
    this.quantity,
  });
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late _ItemModel _model;

  @override
  void initState() {
    _model = _ItemModel(
      name: widget.initialItem?.name,
      description: widget.initialItem?.description,
      quantity: widget.initialItem?.quantity,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.initialItem == null ? 'Add' : 'Edit'} Item'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: AdaptivePadding(
        child: _buildForm(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _save();
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SpacedColumn(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name *',
            ),
            textInputAction: TextInputAction.next,
            initialValue: _model.name,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            onSaved: (String? value) {
              _model.name = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            textInputAction: TextInputAction.newline,
            initialValue: _model.description,
            maxLines: 4,
            minLines: 2,
            onSaved: (String? value) {
              _model.description = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            initialValue: _model.quantity?.toString(),
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (int.tryParse(value ?? '') == null) {
                return 'Quantity must be a number';
              }
              return null;
            },
            onSaved: (String? value) {
              _model.quantity = int.parse(value!);
            },
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (widget.initialItem == null) {
      ShoppingListProvider.instance.addShoppingListItem(
          widget.list,
          ShoppingListItem(
            name: _model.name!,
            description: _model.description,
            quantity: _model.quantity!,
            checked: false,
          ));
    } else {
      widget.initialItem!.update(
          name: _model.name!,
          description: _model.description,
          quantity: _model.quantity!);
    }
    GoRouter.of(context).pop();
  }
}
