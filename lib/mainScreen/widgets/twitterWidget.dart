import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/twitterApiManager.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:tweet_ui/tweet_ui.dart';

class TwitterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TwitterState();
}

class TwitterState extends State<TwitterWidget> {
  List<Tweet> tweetsLoaded = List();
  TwitterApiManager api = TwitterApiManager();
  final loadingDialogManager = LoadingDialogManager();

  double maxId = double.infinity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getTweets();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Scrollbar(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: <Widget>[
              ...tweetsLoaded.map((tweet) =>
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Card (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 2,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: TweetView.fromTweet(tweet)
                          )
                      )
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(bottom: 10),
                child: RaisedButton(
                  elevation: 2,
                  child: Text("Load More"),
                  onPressed: _getNextTweets,
                ),
              )
            ],
          )
        )
      )
    );
  }

  _getTweets() async {
    List<Tweet> tweets = await loadingDialogManager.performLoadingTask(
        context,
        api.getStatuses(), () => null);
    if (tweets == null) return;
    setState(() {
      tweetsLoaded.addAll(tweets);
      if (tweetsLoaded.isNotEmpty) {
        maxId = tweetsLoaded.last.id - 1;
      }
    });
  }

  _getNextTweets() async {
    List<Tweet> tweets = await loadingDialogManager.performLoadingTask(
        context,
        api.getNextStatuses(maxId), () => null);
    if (tweets == null) return;
    if (tweetsLoaded.isNotEmpty && tweets.first.id == tweetsLoaded.last.id) {
      tweetsLoaded.removeLast();
    }
    setState(() {
      tweetsLoaded.addAll(tweets);
      if (tweetsLoaded.isNotEmpty) {
        maxId = tweetsLoaded.last.id - 1;
      }
    });
  }
}