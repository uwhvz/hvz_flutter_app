
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/util.dart';

class SupplyCodeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupplyCodeState();
}

class _SupplyCodeState extends State<SupplyCodeWidget> {
  final TextEditingController _codeController = TextEditingController();
  final LoadingDialogManager _loadingDialogManager = LoadingDialogManager();
  final APIManager _apiManager = APIManager();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _codeController,
              decoration: InputDecoration(
                  fillColor: Color.fromRGBO(0, 0, 0, 0),
                  labelText: 'Supply Code'
              )
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              onPressed: () => _submit(context),
              child: Text("Submit")
            )
          ),
        ],
      )
    );
  }

  Future _submit(BuildContext context) async {
    List<dynamic> response = await _loadingDialogManager.performLoadingTask(
        context,
      _apiManager.claimSupplyCode(_codeController.text),
      () => Utilities.showErrorDialog(context, 'An application error occured. Please contact the HvZ moderator team'));

    if (response == null) {
      return; // error happened above
    }
    if (response[0] == 200) {
      _apiManager.getAccountInfo();
      Utilities.showSuccessDialog(
        context,
        "Successfully redeemed supply code.",
      );
    } else {
      if (response[1].isNotEmpty)
        Utilities.showErrorDialog(context, response[1]);
      else
        Utilities.showErrorDialog(context, "An error has occured. Please contact the HVZ mod team for more details.");
    }
  }
}
