import 'package:flutter/material.dart';

class SpacedRow extends StatelessWidget {
  const SpacedRow(
      {Key? key,
      required this.children,
      this.mainAxisSize = MainAxisSize.min,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.spacing = 16})
      : super(key: key);

  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (final child in children) ...[
          child,
          if (child != children.last) SizedBox(width: spacing),
        ],
      ],
    );
  }
}
