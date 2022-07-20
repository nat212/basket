import 'package:basket/init.dart';
import 'package:basket/src/shared/app.dart';
import 'package:flutter/material.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.DEV;
  await initialiseApp();
  runApp(const BasketApp());
}
