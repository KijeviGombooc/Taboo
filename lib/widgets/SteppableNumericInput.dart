import 'package:flutter/material.dart';

class SteppableNumericInput extends StatefulWidget {
  final int minVal;
  final int initVal;
  final int maxVal;
  final ValueChanged<int> onChanged;

  const SteppableNumericInput(
      {required this.onChanged,
      this.minVal = 2,
      this.initVal = 2,
      this.maxVal = 10});
  @override
  _SteppableNumericInputState createState() => _SteppableNumericInputState();
}

class _SteppableNumericInputState extends State<SteppableNumericInput> {
  late int value;
  bool canDecrement = true;
  bool canIncrement = true;

  @override
  void initState() {
    super.initState();
    value = widget.initVal;
    canDecrement = value > widget.minVal;
    canIncrement = value < widget.maxVal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: IconButton(
                iconSize: 64,
                onPressed: canDecrement ? _decrement : null,
                icon: Icon(Icons.arrow_left),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value.toString()),
              ),
            ),
            IconButton(
              iconSize: 64,
              onPressed: canIncrement ? _increment : null,
              icon: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ],
    );
  }

  void _increment() {
    setState(() {
      value++;
      canDecrement = value > widget.minVal;
      canIncrement = value < widget.maxVal;
    });
    widget.onChanged(value);
  }

  void _decrement() {
    setState(() {
      value--;
      canDecrement = value > widget.minVal;
      canIncrement = value < widget.maxVal;
    });
    widget.onChanged(value);
  }
}
