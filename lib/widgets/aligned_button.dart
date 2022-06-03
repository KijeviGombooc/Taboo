import 'package:flutter/material.dart';

class AlignedButton extends StatelessWidget {
  final Alignment alignment;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final String text;
  final MaterialStateProperty<Color?>? color;

  const AlignedButton({
    required this.alignment,
    this.width,
    this.height,
    required this.onPressed,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          child: Text(text),
          onPressed: onPressed,
          style: ButtonStyle(backgroundColor: color),
        ),
      ),
    );
  }
}
