import 'package:basket/src/features/shopping_lists/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/features/shopping_lists/providers/providers.dart';

Future<void> initialiseApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  await _initProviders();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
}

Future<void> _initProviders() async {
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingListItemAdapter());
  await ShoppingListProvider.initialise();
}