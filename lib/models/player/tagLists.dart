import 'tag.dart';

class TagLists {
  List<Tag> verified;
  List<Tag> unverified;
  List<Tag> received;

  TagLists({
    this.verified,
    this.unverified,
    this.received
  });

  factory TagLists.fromJson(Map<String, dynamic> json) {
    List<dynamic> verified = json["verified"];
    List<dynamic> unverified = json["unverified"];
    List<dynamic> received = json["received"];

    List<Tag> verifiedTags = verified.map(
        (tagData) => Tag.fromJson(tagData)
    ).toList();
    List<Tag> unverifiedTags = unverified.map(
        (tagData) => Tag.fromJson(tagData)
    ).toList();
    List<Tag> receivedTags = received.map(
        (tagData) => Tag.fromJson(tagData)
    ).toList();

    return TagLists(
      verified: verifiedTags,
      unverified: unverifiedTags,
      received: receivedTags,
    );
  }

  Map<String, dynamic> toJson() => {
    "verified": verified,
    "unverified": unverified,
    "received": received,
  };
}
