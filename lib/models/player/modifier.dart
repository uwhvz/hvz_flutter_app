class Modifier {
  int amount;
  String type;

  Modifier({
    this.amount,
    this.type,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
    amount: json["modifier_amount"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "type": type,
  };
}