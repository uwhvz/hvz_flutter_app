import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/constants.dart';
import 'package:hvz_flutter_app/models/twitter/tweetList.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:twitter_api/twitter_api.dart';

class TwitterApiManager {
  static TwitterApiManager _instance = TwitterApiManager._internal();

  factory TwitterApiManager() {
    return _instance;
  }

  TwitterApiManager._internal();

  final twitterAuth = twitterApi(
      consumerKey: Constants.TWITTER_API_KEY,
      consumerSecret: Constants.TWITTER_API_SECRET_KEY,
      token: Constants.TWITTER_API_TOKEN,
      tokenSecret: Constants.TWITTER_API_TOKEN_SECRET
  );

  Future<List<Tweet>> getNextStatuses(double maxId) async{
    var response = await twitterAuth.getTwitterRequest(
      "GET",
      "statuses/user_timeline.json",
      options: {
        "screen_name": "HVZAlertSystem",
        "count": "50",
        "tweet_mode": "extended",
        "max_id": maxId.toString()
      }
    );

    return TweetList.fromJson(json.decode(response.body)).tweets;
  }

  Future<List<Tweet>> getStatuses() async {
    var response = await twitterAuth.getTwitterRequest(
        "GET",
        "statuses/user_timeline.json",
        options: {
          "screen_name": "HVZAlertSystem",
          "count": "50",
          "tweet_mode": "extended",
        }
    );

    return TweetList.fromJson(json.decode(response.body)).tweets;
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}