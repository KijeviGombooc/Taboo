import 'package:flutter/material.dart';
import 'package:taboo/models/settings.dart';
import 'package:taboo/models/word.dart';

import 'clock_widget.dart';
import 'word_widget.dart';

class GameRunningWidget extends StatelessWidget {
  final Word word;
  final VoidCallback onTimeDone;

  const GameRunningWidget({
    required this.word,
    required this.onTimeDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: WordWidget(
            word: word,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: ClockWidget(
              // key: fullDuration.inMilliseconds == 0 ? Key("0") : null,
              fullDuration: Duration(seconds: Settings.gameDuration),
              onTimeDone: onTimeDone,
            ),
          ),
        ),
      ],
    );
  }
}
