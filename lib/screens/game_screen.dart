import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taboo/main.dart';
import 'package:taboo/models/db_helper.dart';
import 'package:taboo/models/settings.dart';
import 'package:taboo/models/word.dart';
import 'package:taboo/widgets/aligned_button.dart';
import 'package:taboo/widgets/aligned_button_with_score.dart';
import 'package:taboo/widgets/game_over_widget.dart';
import 'package:taboo/widgets/game_running_widget.dart';

class GameScreen extends StatefulWidget {
  final int gameID;
  final int teamID;

  const GameScreen({required this.gameID, required this.teamID});
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const double lowerButtonHeight = 75;
  Word? _word;
  bool _isGameOver = false;
  final List<Word> _wrongs = [];
  final List<Word> _corrects = [];
  int _remainingSkips = 0;

  @override
  void initState() {
    super.initState();
    _onResetPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Taboo"),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: MyApp.elevatedButtonHeight + 10,
                    bottom: lowerButtonHeight + 10),
                child: _isGameOver
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameOverWidget(
                          wrongs: _wrongs,
                          corrects: _corrects,
                          onWrongsChanged: () => setState(() {}),
                          onCorrectsChanged: () => setState(() {}),
                          onContinuePressed: _onContinuePressed,
                        ),
                      )
                    : _word == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GameRunningWidget(
                            word: _word as Word,
                            onTimeDone: _onTimeDone,
                          ),
              ),
              AlignedButton(
                width: 150,
                alignment: Alignment.topLeft,
                onPressed: _onResetPressed,
                text: "Reset",
              ),
              AlignedButton(
                width: 150,
                alignment: Alignment.topRight,
                onPressed: _isGameOver ? null : () => _onFastForwardPressed(),
                text: "Fast forward",
              ),
              AlignedButtonWithScore(
                color: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  const Set<MaterialState> interactiveStates = <MaterialState>{
                    MaterialState.disabled,
                  };
                  if (states.any(interactiveStates.contains)) {
                    return const Color(0xFFEF9A9A);
                  }
                  return const Color(0xFFF44336);
                }),
                height: lowerButtonHeight,
                alignment: Alignment.bottomLeft,
                onPressed: _isGameOver ? null : _onWrongPressed,
                text: "Wrong",
                score: _wrongs.length.toString(),
              ),
              AlignedButtonWithScore(
                color: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  const Set<MaterialState> interactiveStates = <MaterialState>{
                    MaterialState.disabled,
                  };
                  if (states.any(interactiveStates.contains)) {
                    return const Color(0xFFA5D6A7);
                  }
                  return const Color(0xFF4CAF50);
                }),
                height: lowerButtonHeight,
                alignment: Alignment.bottomRight,
                onPressed: _isGameOver ? null : _onCorrectPressed,
                text: "Correct",
                score: _corrects.length.toString(),
              ),
              AlignedButton(
                height: lowerButtonHeight,
                alignment: Alignment.bottomCenter,
                onPressed:
                    _isGameOver || _remainingSkips <= 0 && _remainingSkips != -1
                        ? null
                        : _onSkipPressed,
                text: "Skip",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTimeDone() {
    setState(() {
      _isGameOver = true;
    });
  }

  void _onContinuePressed() {
    print("continue pressed");
    DBHelper.updateScore(
      widget.gameID,
      widget.teamID,
      _corrects.length - _wrongs.length,
    ).then(
      (_) {
        DBHelper.setNextTeam(widget.gameID).then(
          (_) {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _onCorrectPressed() {
    if (_word == null) return;
    _corrects.add(_word as Word);
    _getRandomWord();
  }

  void _onWrongPressed() {
    if (_word == null) return;
    _wrongs.add(_word as Word);
    _getRandomWord();
  }

  void _onResetPressed() {
    setState(() {
      _word = null;
      _wrongs.clear();
      _corrects.clear();
      _isGameOver = false;
      _remainingSkips = Settings.skipCount;
    });
    _getRandomWord();
  }

  void _onSkipPressed() {
    setState(() {
      _remainingSkips--;
    });
    _getRandomWord();
  }

  void _onFastForwardPressed() {
    setState(() {
      _isGameOver = true;
    });
  }

  void _getRandomWord() {
    // Future.delayed(Duration(seconds: 1)).then((value) {
    DBHelper.getWordCount().then((count) {
      DBHelper.getWord(Random().nextInt(count)).then((word) {
        setState(() {
          _word = word;
        });
      });
      // });
    });
  }
}
