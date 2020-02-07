import 'models/player/playerInfo.dart';

class ApplicationData {
  static final ApplicationData _singleton = ApplicationData._internal();

  PlayerInfo info = PlayerInfo();
  bool loggedIn = false;

  factory ApplicationData() {
    return _singleton;
  }

  ApplicationData._internal();
}