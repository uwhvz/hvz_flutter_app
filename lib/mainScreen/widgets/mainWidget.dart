import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/mainScreen/widgets/dialogs/main_factionDialog.dart';
import 'package:hvz_flutter_app/mainScreen/widgets/dialogs/main_playerCodeDialog.dart';
import 'package:hvz_flutter_app/mainScreen/widgets/dialogs/main_supplyDialog.dart';
import 'package:hvz_flutter_app/models/player/game.dart';

enum RowPosition { LEFT, RIGHT, MIDDLE, SINGLE }

class MainWidget extends StatelessWidget {
  final playerInfo = ApplicationData().info;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Card(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          playerInfo.name,
                          textAlign: TextAlign.center,
                          textScaleFactor: 4.0,
                        ),
                    )),
              )),
        ]),
        ...(playerInfo.game.status == Game.FINISHED
            ? _getGameFinishedLayout()
            : _getActiveLayout(context))
      ],
    );
  }

  List<Widget> _getActiveLayout(BuildContext context) {
    return <Widget>[
      Expanded(
          flex: 1,
          child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _generateCard(RowPosition.LEFT, "Player Code",
                      playerInfo.code, context, _expandPlayerCode),
                  _generateCard(
                      RowPosition.RIGHT,
                      "Shop Points",
                      playerInfo.shopScore.toString(),
                      context,
                      (context) => null),
                ],
              ))),
      Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _generateCard(RowPosition.LEFT, "Team",
                    _getTeam(playerInfo.roleChar), context, (context) => null),
                Visibility(
                  visible: playerInfo.faction != null,
                  child: playerInfo.faction == null
                      ? Container()
                      : _generateCard(RowPosition.MIDDLE, "Faction",
                          playerInfo.faction.name, context, _expandFaction),
                ),
                _generateScoreCard(context)
              ],
            ),
          )),
      Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _generateCard(RowPosition.SINGLE, "Game", playerInfo.game.name,
                    context, (context) => null),
              ],
            ),
          ))
    ];
  }

  List<Widget> _getGameFinishedLayout() {
    return <Widget>[
      Expanded(
          child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Card(
                        elevation: 2,
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "Our ${playerInfo.game.name} game has finished.",
                                    textScaleFactor: 2.5,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "Thanks for playing! Be sure to join our Facebook group for more information regarding minigames and future weeklongs!",
                                  textScaleFactor: 1.5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              ],
                            ))),
                  )
                ],
              ),
            )
      )
    ];
  }

  String _getTeam(String roleChar) {
    switch (roleChar[0]) {
      case 'H':
        return "Human";
      case 'Z':
        return "Zombie";
      case 'S':
        return "Spectator";
      default:
        throw ArgumentError("Invalid role");
    }
  }

  Expanded _generateCard(RowPosition position, String label, String data,
      BuildContext context, Function(BuildContext) onClick) {
    double left = 5;
    double right = 5;

    switch (position) {
      case RowPosition.SINGLE:
        left = 10;
        right = 10;
        break;
      case RowPosition.LEFT:
        left = 10;
        break;
      case RowPosition.RIGHT:
        right = 10;
        break;
      default:
    }
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: left, right: right),
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: InkWell(
            onTap: () => onClick(context),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  Text(
                    data,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateScoreCard(BuildContext context) {
    switch (_getTeam(playerInfo.roleChar)) {
      case "Human":
        return _generateCard(RowPosition.RIGHT, "Supplied?",
            playerInfo.score >= 5 ? "Yes" : "No", context, _expandSupply);
      case "Zombie":
        return _generateCard(RowPosition.RIGHT, "Score",
            playerInfo.score.toString(), context, (context) => null);
      default:
        return Container();
    }
  }

  _expandPlayerCode(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayerCodeDialog(context, playerInfo, okButton);
      },
    );
  }

  _expandFaction(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FactionDialog(context, playerInfo.faction, okButton);
      },
    );
  }

  _expandSupply(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SupplyDialog(context, playerInfo, okButton);
      },
    );
  }
}
