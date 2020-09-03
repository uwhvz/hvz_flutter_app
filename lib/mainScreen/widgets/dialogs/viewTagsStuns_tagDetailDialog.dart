import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/player/tag.dart';
import 'package:intl/intl.dart';

class TagDetailsDialog extends AlertDialog {
  final Tag _tag;
  final Widget _dismiss;
  final String _action;

  TagDetailsDialog(this._tag, this._dismiss):
      _action = _tag.tagType == "S" ? "Stun": "Tag";

  @override
  List<Widget> get actions => <Widget>[_dismiss];

  @override
  Widget get content {
    DateTime time = DateTime.parse(_tag.time).toLocal();

    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _action,
              textScaleFactor: 2.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "${_tag.initiatorName} submitted a ${_action.toLowerCase()} on ${_tag.receiverName} on ${DateFormat('MMM d, h:mm a').format(time)}",
                style: TextStyle(fontStyle: FontStyle.italic),
                textScaleFactor: 1.3,
              )
            ),
            Text(
              "Location:",
              textScaleFactor: 1.3,
            ),
            Text(
              _tag.location.isNotEmpty? _tag.location : "N/A",
              textScaleFactor: 1.3,
              style: TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Notes:",
                textScaleFactor: 1.3,
              ),
            ),
            Text(
              _tag.description.isNotEmpty ? _tag.description : "None given.",
              textScaleFactor: 1.3,
              style: TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            )
          ],
        )
    );
  }
}