import 'package:flutter/material.dart';
import 'package:akon/models/word.dart';

import 'words_review_widget.dart';

class GameOverWidget extends StatelessWidget {
  final List<Word> wrongs;
  final List<Word> corrects;
  final VoidCallback onWrongsChanged;
  final VoidCallback onCorrectsChanged;
  final VoidCallback onContinuePressed;

  const GameOverWidget({
    required this.wrongs,
    required this.corrects,
    required this.onWrongsChanged,
    required this.onCorrectsChanged,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: WordsReviewWidget(
                          text: "Reset wrongs",
                          words: wrongs,
                          onListChange: onWrongsChanged,
                        ),
                      ),
                      Flexible(
                        child: WordsReviewWidget(
                          text: "Reset corrects",
                          words: corrects,
                          onListChange: onCorrectsChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: ElevatedButton(
                  onPressed: onContinuePressed,
                  child: Text("Continue"),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: WordsReviewWidget(
                            text: "Reset wrongs",
                            words: wrongs,
                            onListChange: onWrongsChanged,
                          ),
                        ),
                        Flexible(
                          child: WordsReviewWidget(
                            text: "Reset corrects",
                            words: corrects,
                            onListChange: onCorrectsChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: onContinuePressed,
                  child: Text("Continue"),
                ),
              ),
            ],
          );
  }
}
