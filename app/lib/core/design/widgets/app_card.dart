import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.header,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: padding, child: child),
    );

    if (header == null) return card;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header!,
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
