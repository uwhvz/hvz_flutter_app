import 'faction.dart';
import 'game.dart';

class PlayerInfo {
  String code;
  String roleChar;
  bool isOz;
  String name;
  String email;
  int score;
  int shopScore;
  Faction faction;
  Game game;

  PlayerInfo({
    this.code,
    this.roleChar,
    this.isOz,
    this.name,
    this.email,
    this.score,
    this.shopScore,
    this.faction,
    this.game
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => PlayerInfo(
    code: json["code"],
    roleChar: json["roleChar"],
    isOz: json["is_oz"],
    name: json["name"],
    email: json["email"],
    score: json["score"],
    shopScore: json["shop_score"],
    faction: json["faction"] == null ? null : Faction.fromJson(json["faction"]),
    game: Game.fromJson(json["game"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "roleChar": roleChar,
    "is_oz": isOz,
    "name": name,
    "email": email,
    "faction": faction.toJson(),
    "game": game.toJson()
  };
}