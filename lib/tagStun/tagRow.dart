import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/mainScreen/widgets/dialogs/viewTagsStuns_tagDetailDialog.dart';
import 'package:intl/intl.dart';
import 'package:hvz_flutter_app/models/player/tag.dart';

class TagRow extends StatelessWidget{
  final Tag _tag;
  final bool _showInitiator;

  TagRow(this._tag, this._showInitiator);

  @override
  Widget build(BuildContext context) {
    String targetText;
    String actionText = _tag.tagType == "S" ? "Stun" : "Tag";

    if (_showInitiator) {
      targetText = "$actionText from ${_tag.initiatorName}(${_tag.initiatorRole})";
    } else {
      targetText = "$actionText on ${_tag.receiverName}(${_tag.receiverRole})";
    }

    DateTime time = DateTime.parse(_tag.time).toLocal();

    return InkWell(
        onTap: () => _showTagDetails(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 1.0
              )
            )
          ),
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        targetText,
                        maxLines: 1,
                        textScaleFactor: 1.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "${DateFormat('MMM d, h:mm a').format(time)}",
                          maxLines: 1,
                          textScaleFactor: 1.3,
                        )
                      ),
                    ]
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "+${_tag.points.toString()}",
                            maxLines: 1,
                            textScaleFactor: 2,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Icon(
                            Icons.arrow_right,
                            size: 36.0
                          )
                        ],
                      )
                    ]
                ),
              ],
            )
        )
    );
  }

  void _showTagDetails(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TagDetailsDialog(_tag, okButton);
      },
    );
  }
}