import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:akon/models/clock_painter.dart';
import 'package:akon/models/settings.dart';

class ClockWidget extends StatefulWidget {
  final Duration fullDuration;
  final VoidCallback onTimeDone;

  const ClockWidget({
    required this.fullDuration,
    required this.onTimeDone,
  });

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin<ClockWidget> {
  late AnimationController _animationController;

  String get clockText {
    int currentMilliseconds = (_animationController.value *
            _animationController.duration!.inMilliseconds)
        .toInt();
    Duration currentDuration = Duration(milliseconds: currentMilliseconds);
    String mins = (currentDuration.inMinutes % 60).toString().padLeft(2, '0');
    String secs = (currentDuration.inSeconds % 60).toString().padLeft(2, '0');
    String msecs = (currentDuration.inMilliseconds % 1000)
        .toString()
        .padLeft(3, '0')
        .substring(0, 2);
    return "$mins:$secs:$msecs";
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: widget.fullDuration,
    );
    _animationController.addListener(_onTick);
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: Settings.pauseState != 1 ? null : onTap,
        onLongPress: Settings.pauseState != 2 ? null : onLongPress,
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: ClockPainter(animation: _animationController),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  clockText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTick() {
    if (_animationController.value <= 0) {
      widget.onTimeDone();
    }
    setState(() {});
  }

  void onTap() {
    pauseUnpause();
  }

  void onLongPress() {
    pauseUnpause();
  }

  void pauseUnpause() {
    setState(() {
      if (_animationController.isAnimating)
        _animationController.stop();
      else {
        _animationController.reverse();
      }
    });
  }
}
