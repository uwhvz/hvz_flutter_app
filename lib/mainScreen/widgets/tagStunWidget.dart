import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:hvz_flutter_app/tagStun/tagStunManualEntry.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/util.dart';

class TagStunWidget extends StatelessWidget {
  final APIManager _apiManager = APIManager();
  final PlayerInfo _playerInfo = ApplicationData().info;
  final LoadingDialogManager _loadingDialogManager = LoadingDialogManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(10),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () =>_scan(context),
              child: Text(
                  "Scan a QR code"
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            child: OutlineButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TagStunManualEntry()
                )),
                child: Text(
                    "Manual Entry"
                )
            )
          )
        ],
      )
    );
  }

  Future _scan(BuildContext context) async {
    try {
      print("Here");
      String barcode = await BarcodeScanner.scan();

      _sendTagStun(context, barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Utilities.showErrorDialog(context, 'The user did not grant camera permission!');
      } else {
        // Do nothing.
      }
    } catch (e) {
      // Do nothing.
    }
  }

  Future _sendTagStun(BuildContext context, String code) async {
    List<dynamic> response = await _loadingDialogManager.performLoadingTask(
        context,
        _apiManager.stunOrTag(
          code,
          DateTime.now().millisecondsSinceEpoch~/1000,
          "",
          "Verified by QR code through mobile app."),
        () => Utilities.showErrorDialog(context, 'An application error occured. Please contact the HvZ moderator team'));

    if (response == null) {
      return; // error happened above
    }
    if (response[0] == 200) {
      _apiManager.getAccountInfo();
      String actionString;
      if (_playerInfo.roleChar == 'H')
        actionString = "stunned";
      else
        actionString = "tagged";
      Utilities.showSuccessDialog(
        context,
        "Successfully $actionString player ${response[1]}",
      );
    } else {
      if (response[1].isNotEmpty)
        Utilities.showErrorDialog(context, response[1]);
      else
        Utilities.showErrorDialog(context, "An error has occured. Please contact the HVZ mod team for more details.");
    }
  }
}