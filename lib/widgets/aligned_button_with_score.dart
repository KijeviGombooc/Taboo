import 'package:flutter/material.dart';

class AlignedButtonWithScore extends StatelessWidget {
  final Alignment alignment;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final String text;
  final String score;
  final MaterialStateProperty<Color?>? color;

  const AlignedButtonWithScore({
    required this.alignment,
    this.width,
    this.height,
    required this.onPressed,
    required this.text,
    required this.score,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                // color: color!.resolve(<MaterialState>{
                //   MaterialState.focused,
                // }),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(score),
              ),
            ),
            SizedBox(
              width: width,
              height: height,
              child: ElevatedButton(
                child: Text(text),
                onPressed: onPressed,
                style: Theme.of(context)
                    .elevatedButtonTheme
                    .style!
                    .copyWith(backgroundColor: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
