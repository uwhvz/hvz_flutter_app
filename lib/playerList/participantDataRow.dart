import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/userInfo/participant.dart';

class ParticipantDataRow extends StatelessWidget {
  final Participant _participant;
  final bool _topBorder;

  ParticipantDataRow(this._participant, this._topBorder);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: _topBorder ? Border() : Border(
                top: BorderSide(
                    color: Colors.blueGrey,
                    width: 1.0
                )
            )
        ),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _participant.name,
                      maxLines: 1,
                      textScaleFactor: 1.5,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: Text(
                          _participant.role,
                          maxLines: 1,
                          textScaleFactor: 1.3,
                        )
                    ),
                  ]
              ),
            ),
            Expanded(
              child: Text(
                "Score: ${_participant.score}",
                textScaleFactor: 1.3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              )
            )
          ],
        )
    );
  }
}