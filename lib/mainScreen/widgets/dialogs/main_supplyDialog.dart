import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';

class SupplyDialog extends AlertDialog{
  final BuildContext parentContext;
  final PlayerInfo info;
  final Widget dismiss;
  final bool supplied;

  SupplyDialog(this.parentContext, this.info, this.dismiss) :
        supplied = info.score >= 5;

  @override
  List<Widget> get actions => <Widget>[dismiss];

  @override
  Widget get content => Container(
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
                      "Supplied?",
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
          Container (
            child: Text (
              supplied ? "Yes" : "No",
              textAlign: TextAlign.center,
              textScaleFactor: 2.5,
              style: TextStyle(
                color: supplied ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container (
            padding: EdgeInsets.only(left:10, right:10),
            child: Text(
              _getSuppliedText(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
              style: TextStyle(
                  fontStyle: FontStyle.italic
              ),
            ),
          ),
      ]
    )
  );

  String _getSuppliedText() {
    switch(supplied) {
      case true:
        return "Congratulations, you're supplied! Go stun some zombies!";
      case false:
        return "You are NOT supplied. Go stun a zombie or redeem a supply code or you will automatically be turned into a zombie at 5pm on Friday.";
    }
    throw ArgumentError("No supplies");
  }

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0);
}