import 'package:flutter/material.dart';
import 'package:taboo/models/Settings.dart';
import 'package:taboo/widgets/SteppableNumericInput.dart';

class SettingsScreen extends StatelessWidget {
  static const int skipOptionCount = 10;
  static const clockSecondsOptionCount = 10 * 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Team count:"),
                SteppableNumericInput(
                  onChanged: _onTeamCountChanged,
                  initVal: Settings.teamCount,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Clock seconds:"),
                Container(
                  height: 200,
                  width: 120,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    diameterRatio: 0.9,
                    controller: FixedExtentScrollController(
                        initialItem: Settings.gameDuration),
                    onSelectedItemChanged: _onDurationSelected,
                    itemExtent: 40,
                    children: List.generate(
                      clockSecondsOptionCount,
                      (i) => Text(
                        i.toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Available skips:"),
                Container(
                  height: 200,
                  width: 120,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    diameterRatio: 0.9,
                    controller: FixedExtentScrollController(
                        initialItem: Settings.skipCount > skipOptionCount
                            ? 0
                            : Settings.skipCount + 1),
                    onSelectedItemChanged: (index) => _onSkipCountChanged(
                        index == 0 ? 1000 * 1000 * 1000 : index - 1),
                    itemExtent: 40,
                    children: List.generate(
                      skipOptionCount + 1,
                      (i) => Center(
                        child: Text(
                          i == 0 ? "ANY" : (i - 1).toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Pause method:"),
                Container(
                  height: 200,
                  width: 120,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    diameterRatio: 0.9,
                    controller: FixedExtentScrollController(
                        initialItem: Settings.pauseState),
                    onSelectedItemChanged: _onPauseMethodChanged,
                    itemExtent: 40,
                    children: List.generate(
                      3,
                      (i) => Center(
                        child: Text(_getPauseTextFromIndex(i)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPauseTextFromIndex(int index) {
    switch (index) {
      case 0:
        return "Off";
      case 1:
        return "Press";
      case 2:
        return "Hold";
      default:
    }
    return "ERROR";
  }

  _onDurationSelected(int newVal) {
    Settings.gameDuration = newVal;
  }

  _onTeamCountChanged(int newVal) {
    Settings.teamCount = newVal;
  }

  _onSkipCountChanged(int newVal) {
    Settings.skipCount = newVal;
    print(newVal);
  }

  _onPauseMethodChanged(int value) {
    Settings.pauseState = value;
  }
}
