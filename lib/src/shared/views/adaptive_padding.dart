import 'dart:math';

import 'package:flutter/material.dart';

class AdaptivePadding extends StatelessWidget {
  const AdaptivePadding({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: min(constraints.maxWidth, 600),
          ),
          child: child,
        ),
      ),
    );
  }
}
