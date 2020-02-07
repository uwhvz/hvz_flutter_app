import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagStunWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Card(
        elevation: 2,
        child: Center(
          child: Text(
            "This feature has not been implemented yet. Check again in the near future!",
            textScaleFactor: 4.0,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          )
        )
      )
    );
  }
}