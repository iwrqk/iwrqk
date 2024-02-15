import 'package:flutter/material.dart';

class LoadFail extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRefresh;

  const LoadFail({super.key, required this.errorMessage, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh, size: 42),
          onPressed: onRefresh,
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            errorMessage,
            textAlign: TextAlign.left,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        )
      ],
    );
  }
}
