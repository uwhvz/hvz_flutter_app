
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/userInfo/participant.dart';
import 'package:hvz_flutter_app/models/userInfo/playerList.dart';
import 'package:hvz_flutter_app/playerList/participantDataRow.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/utilities/util.dart';

class PlayerListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerListWidget();
}

class _PlayerListWidget extends State<PlayerListWidget> {
  final LoadingDialogManager _loadingDialogManager = LoadingDialogManager();
  final APIManager _apiManager = APIManager();
  var _playerList = List<Participant>();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadPlayerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Container();
    }
    if (_playerList == null || _playerList.isEmpty){
      return Center(
        child: Text(
          "It looks like there aren't any players in your current game. Either this app wasn't able to load the data correctly or there's an error on the server. Please contact the HvZ moderator team.",
          textScaleFactor: 1.3,
          textAlign: TextAlign.center,
        ),
      );
    }

    var rows = <Widget>[];

    _playerList.forEach((participant) {
      rows.add(
        ParticipantDataRow(participant, participant == _playerList.first)
      );
    });

    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              children: rows
            ),
          ),
        )
      ],
    );
  }

  void _loadPlayerList() async {
    PlayerList received = await _loadingDialogManager.performLoadingTask(
        context,
        _apiManager.getPlayerList(),
            () => null);

    if (received == null) {
      Utilities.showErrorDialog(context, "Error retrieving player list.");
      return;
    }

    setState(() {
      _loaded = true;
      _playerList.clear();
      _playerList.addAll(received.players);
      _playerList.addAll(received.mods);
      _playerList.addAll(received.spectators);
      _playerList.sort((first, second) => first.name.compareTo(second.name));
    });
  }
}