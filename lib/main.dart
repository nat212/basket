import 'package:basket/src/shared/app.dart';
import 'package:flutter/material.dart';

import 'init.dart';

void main() async {
  await initialiseApp();
  runApp(const BasketApp());
}
