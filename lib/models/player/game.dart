class Game {
  String name;
  String status;
  String startTimestamp;
  String endTimestamp;

  static const String RUNNING = "running";
  static const String FINISHED = "finished";
  static const String SIGNUPS = "signups";

  Game({
    this.name,
    this.status,
    this.startTimestamp,
    this.endTimestamp,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    name: json["name"],
    status: json["status"],
    startTimestamp: json["started_on"],
    endTimestamp: json["ended_on"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "status": status,
    "started_on": startTimestamp,
    "ended_on": endTimestamp
  };
}