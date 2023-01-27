import 'package:flutter/material.dart';

class HomeMenuButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const HomeMenuButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text, 
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}