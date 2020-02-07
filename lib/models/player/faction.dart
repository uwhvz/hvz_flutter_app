
import 'modifier.dart';

class Faction {
  String name;
  String description;
  List<Modifier> modifiers;

  Faction({
    this.name,
    this.description,
    this.modifiers
  });

  factory Faction.fromJson(Map<String, dynamic> json) => Faction(
    name: json["name"],
    description: json["description"],
    modifiers: _getModifiers(json)
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "modifiers": modifiers.map((modifier){
      modifier.toJson();
    })
  };

  static List<Modifier> _getModifiers(Map<String, dynamic> json) {
    var modifiers = new List<Modifier>();
    json['modifiers'].forEach((v) {
      modifiers.add(new Modifier.fromJson(v));
    });
    return modifiers;
  }
}