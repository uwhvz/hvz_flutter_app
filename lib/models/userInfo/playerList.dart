import 'simpleModerator.dart';
import 'simplePlayer.dart';
import 'simpleSpectator.dart';

class PlayerList {
  List<SimpleModerator> mods;
  List<SimplePlayer> players;
  List<SimpleSpectator> spectators;

  PlayerList({
    this.mods,
    this.players,
    this.spectators
  });

  factory PlayerList.fromJson(Map<String, dynamic> json, bool shouldShowPlayerRoles) {
    List<dynamic> mods = json["moderators"];
    List<dynamic> players = json["players"];
    List<dynamic> spectators = json["spectators"];

    return PlayerList(
      mods: mods.map((modData) => SimpleModerator.fromJson(modData)).toList(),
      players: players.map((playerData) => SimplePlayer.fromJson(playerData, shouldShowPlayerRoles)).toList(),
      spectators: spectators.map((spectatorData) => SimpleSpectator.fromJson(spectatorData)).toList(),
    );
  }

  bool isEmpty() => mods.isEmpty && players.isEmpty && spectators.isEmpty;
}
