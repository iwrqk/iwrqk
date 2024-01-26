import 'package:flutter/material.dart';

class AppBarSwitcher extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSwitcher({
    required this.primary,
    required this.secondary,
    required this.visible,
    Key? key,
  }) : super(key: key);

  final PreferredSizeWidget primary;
  final PreferredSizeWidget secondary;
  final bool visible;
  @override
  Size get preferredSize => primary.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !visible ? primary : secondary,
    );
  }
}
