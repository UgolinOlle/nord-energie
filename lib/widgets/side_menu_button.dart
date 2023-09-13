import 'package:flutter/material.dart';

class SideMenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SideMenuButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white, size: 30,),
      onPressed: onPressed,
    );
  }
}
