
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PlayerCodeDialog extends AlertDialog {
  final BuildContext parentContext;
  final PlayerInfo playerInfo;
  final Widget dismiss;

  PlayerCodeDialog(this.parentContext, this.playerInfo, this.dismiss);

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0);

  @override
  List<Widget> get actions => <Widget>[dismiss];

  @override
  Widget get content => Container(
    width: 250.0,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Container(
                      color: Theme.of(parentContext).primaryColor,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Player Code",
                        textScaleFactor: 3.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                )
              ]
          ),
          Text(
            playerInfo.code,
            textScaleFactor: 2.0,
          ),
          Container (
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: QrImage(
              data: playerInfo.code,
              version: QrVersions.auto,
            ),
          )
          
        ]
    ),
  );
}