import 'package:flutter/material.dart';
import 'package:taboo/models/Settings.dart';
import 'package:taboo/models/Word.dart';

import 'ClockWidget.dart';
import 'WordWidget.dart';

class GameRunningWidget extends StatelessWidget {
  final Word word;
  final VoidCallback onTimeDone;

  const GameRunningWidget({
    required this.word,
    required this.onTimeDone,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
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
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Center(
                  child: WordWidget(
                    word: word,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClockWidget(
                    fullDuration: Duration(seconds: Settings.gameDuration),
                    onTimeDone: onTimeDone,
                  ),
                ),
              ),
            ],
          );
  }
}
