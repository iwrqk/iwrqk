import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';

class LoadEmpty extends StatelessWidget {
  const LoadEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.inbox,
          color: Theme.of(context).colorScheme.outline,
          size: 42,
        ),
        const SizedBox(height: 16),
        Text(
          t.refresh.empty,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ],
    );
  }
}
