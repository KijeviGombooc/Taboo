import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static const String _gameDurationKey = "game_duration";
  static const String _teamCountKey = "team_count";
  static const String _skipCountKey = "skip_count";
  static const String _pauseStateKey = "pause_state";
  static int _teamCount = 2;
  static int _gameDuration = 60;
  static int _skipCount = 0;
  static int _pauseState = 1;

  static int get teamCount {
    return _teamCount;
  }

  static int get gameDuration {
    return _gameDuration;
  }

  static int get skipCount {
    return _skipCount;
  }

  static int get pauseState {
    return _pauseState;
  }

  static set teamCount(int val) {
    _teamCount = val;
    SharedPreferences.getInstance().then(
      (sharedPreferences) {
        sharedPreferences.setInt(_teamCountKey, _teamCount);
      },
    );
  }

  static set gameDuration(int val) {
    _gameDuration = val;
    SharedPreferences.getInstance().then(
      (sharedPreferences) {
        sharedPreferences.setInt(_gameDurationKey, _gameDuration);
      },
    );
  }

  static set skipCount(int val) {
    _skipCount = val;
    SharedPreferences.getInstance().then(
      (sharedPreferences) {
        sharedPreferences.setInt(_skipCountKey, _skipCount);
      },
    );
  }

  static set pauseState(int val) {
    _pauseState = val;
    SharedPreferences.getInstance().then(
      (sharedPreferences) {
        sharedPreferences.setInt(_pauseStateKey, _pauseState);
      },
    );
  }

  static init() {
    SharedPreferences.getInstance().then(
      (sharedPreferences) {
        int? teamCount = sharedPreferences.getInt(_teamCountKey);
        int? gameDuration = sharedPreferences.getInt(_gameDurationKey);
        int? skipCount = sharedPreferences.getInt(_skipCountKey);
        int? pauseState = sharedPreferences.getInt(_pauseStateKey);
        if (teamCount == null) {
          sharedPreferences.setInt(_teamCountKey, _teamCount);
        } else {
          _teamCount = teamCount;
        }
        if (gameDuration == null) {
          sharedPreferences.setInt(_gameDurationKey, _gameDuration);
        } else {
          _gameDuration = gameDuration;
        }
        if (skipCount == null) {
          sharedPreferences.setInt(_skipCountKey, _skipCount);
        } else {
          _skipCount = skipCount;
        }
        if (pauseState == null) {
          sharedPreferences.setInt(_pauseStateKey, _pauseState);
        } else {
          _pauseState = pauseState;
        }
      },
    );
  }
}
