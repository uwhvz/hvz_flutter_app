import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/models/player/tagLists.dart';
import 'package:hvz_flutter_app/tagStun/tagRow.dart';
import 'package:hvz_flutter_app/models/player/tag.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PendingTagStunWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PendingTagStunState();
}

class _PendingTagStunState extends State<PendingTagStunWidget> {
  final LoadingDialogManager _loadingDialogManager = LoadingDialogManager();
  final APIManager _apiManager = APIManager();
  TagLists _result = TagLists();
  bool _loaded = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getSubmittedTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Container();
    }
    if (_result.received.isEmpty && _result.verified.isEmpty && _result.unverified.isEmpty) {
      return Center(
        child: Text(
          "You have not submitted or received any tags or stuns. Get out there and play!",
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
        ),
      );
    }

    List<Widget> cards = [
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Total Tag/Stun Points",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      ),
                      Text(
                        _getPointTotal(_result.verified).toString(),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Pending Tag/Stun Points",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      ),
                      Text(
                        _getPointTotal(_result.unverified).toString(),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      )
    ];

    if (_result.unverified.isNotEmpty) {
      cards.add(_generateStunCard(
          "Pending",
          "Please wait for a moderator to approve these. Points will be awarded after stuns are verified.",
          _result.unverified,
          false,
      ));
    }
    if (_result.verified.isNotEmpty) {
      cards.add(_generateStunCard(
          "Verified",
          "These tags/stuns have been approved. Points have already been awarded.",
          _result.verified,
          false,
      ));
    }
    if (_result.received.isNotEmpty) {
      cards.add(_generateStunCard(
          "Received",
          "These tags/stuns have been reported against you.",
          _result.received,
          true,
      ));
    }

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _onRefresh,
      controller: _refreshController,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: cards,
      )
    );
  }

  Widget _generateStunCard(String title, String text, List<Tag> tagList, bool isReceived) {
    List<Widget> stuns = [
      Container(
        margin: EdgeInsets.only(left: 15, top: 15),
        child: Row(
            children: <Widget>[
              Text(
                title,
                textScaleFactor: 2.0,
              ),
            ]
        ),
      ),

      Container(
        margin: EdgeInsets.all(15.0),
        child: Text(
          text,
          textScaleFactor: 1.3,
        )
      )
    ];

    tagList.sort((first, second) {
      DateTime firstTime = DateTime.parse(first.time);
      DateTime secondTime = DateTime.parse(second.time);

      return secondTime.millisecondsSinceEpoch - firstTime.millisecondsSinceEpoch;
    });

    tagList.forEach((tag) {
      stuns.add(
          TagRow(tag, isReceived)
      );
    });
    return Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Container (
          padding: EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: stuns,
          ),
        ),
    );
  }

  void _getSubmittedTags() async {
    TagLists receivedTagLists = await _loadingDialogManager.performLoadingTask(
        context,
        _apiManager.getStunTags(),
            () => null);
    _refreshController.refreshCompleted();
    if (receivedTagLists == null) return;

    setState(() {
      _loaded = true;
      _result = receivedTagLists;
    });
  }

  void _onRefresh() {
    // monitor network fetch
    _getSubmittedTags();
  }

  int _getPointTotal (List<Tag> tags) {
    return tags.fold(0, (sum, tag) => sum + tag.points);
  }
}
