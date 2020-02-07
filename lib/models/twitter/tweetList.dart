import 'package:tweet_ui/models/api/tweet.dart';

class TweetList {
  List<Tweet> tweets;

  TweetList({
    this.tweets
  });

  factory TweetList.fromJson(List<dynamic> parsedJson) {
    List<Tweet> tweets = parsedJson.map((i) => Tweet.fromJson(i)).toList();

    return new TweetList(
      tweets: tweets,
    );
  }
}