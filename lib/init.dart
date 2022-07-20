import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initialiseApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
}