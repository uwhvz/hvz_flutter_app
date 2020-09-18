import 'package:hvz_flutter_app/models/userInfo/participant.dart';

class SimpleSpectator extends Participant {

  SimpleSpectator(String name) {
    super.name = name;
    super.score = "N/A";
    super.role = "Spectator";
  }

  factory SimpleSpectator.fromJson(Map<String, dynamic> json) => SimpleSpectator(
    json["name"],
  );
}