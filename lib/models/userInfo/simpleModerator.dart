import 'package:hvz_flutter_app/models/userInfo/participant.dart';

class SimpleModerator extends Participant {

  SimpleModerator(String name, String processedScore) {
    super.name = name;
    super.score = processedScore.isEmpty ? "N/A" : processedScore;
    super.role = "Moderator";
  }

  factory SimpleModerator.fromJson(Map<String, dynamic> json) => SimpleModerator(
    json["name"],
    json["score"],
  );
}