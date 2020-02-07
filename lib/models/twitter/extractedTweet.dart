
class ExtractedTweet {
  int id;

  ExtractedTweet({
    this.id
  });

  factory ExtractedTweet.fromJson(Map<String, dynamic> json) => ExtractedTweet(
    id: json["id"]
  );
}