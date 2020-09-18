
import 'package:hvz_flutter_app/models/userInfo/participant.dart';

class SimplePlayer extends Participant {

  SimplePlayer(String team, String name, int processedScore) {
    super.name = name;
    super.score = processedScore == -1 ? "Hidden" : processedScore.toString();
    super.role = team;
  }

  factory SimplePlayer.fromJson(Map<String, dynamic> json, bool showRole) {
    String role = "Player";
    if (showRole) {
      role = json["roleChar"] == "H" ? "Human" : "Zombie";
    }
    return SimplePlayer(
      role,
      json["name"],
      json["processedScore"],
    );
  }
}