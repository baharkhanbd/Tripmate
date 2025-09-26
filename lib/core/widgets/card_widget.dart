import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final EdgeInsets? padding;
  final Color? color;

  const CardWidget({
    super.key,
    required this.child,
    this.elevation,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white,
      elevation: elevation ?? 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}
