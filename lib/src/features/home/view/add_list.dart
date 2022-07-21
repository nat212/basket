import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:basket/src/shared/views/adaptive_padding.dart';
import 'package:basket/src/shared/views/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AddListScreen extends StatefulWidget {
  const AddListScreen({Key? key, this.initialList}) : super(key: key);

  final ShoppingList? initialList;

  @override
  State<AddListScreen> createState() => _AddListScreenState();
}

class _ShoppingListModel {
  String? name;
  String? description;

  _ShoppingListModel({this.name, this.description});
}

class _AddListScreenState extends State<AddListScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _ShoppingListModel _model;

  @override
  void initState() {
    super.initState();
    _model = _ShoppingListModel(
      name: widget.initialList?.name,
      description: widget.initialList?.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping List'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _exit();
          },
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _save();
          },
          label: const Text('Save'),
          icon: const Icon(Icons.save)),
    );
  }

  Widget _buildBody() {
    return AdaptivePadding(child: _buildForm());
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
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a name';
              }
              return null;
            },
            initialValue: _model.name,
            onSaved: (String? value) {
              _model.name = value;
            },
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            minLines: 3,
            maxLines: 5,
            maxLength: 250,
            initialValue: _model.description,
            onSaved: (String? value) {
              _model.description = value;
            },
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ShoppingListProvider.instance
          .addShoppingList(_model.name!, _model.description);
      _exit();
    }
  }

  void _exit() {
    GoRouter.of(context).pop();
  }
}
