
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:hvz_flutter_app/tagStun/dateTimePicker.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/util.dart';

class TagStunManualEntry extends StatelessWidget {
  final _title = "Manual Entry";
  final _loadingDialogManager = LoadingDialogManager();
  final _codeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _apiManager = APIManager();
  final _playerInfo = ApplicationData().info;

  DateTime _currentDate = DateTime.now();
  TimeOfDay _currentTime = TimeOfDay.now();
  DateTime _totalDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: _codeController,
                maxLength: 6,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    fillColor: Color.fromRGBO(0, 0, 0, 0),
                    labelText: 'Code'
                )
            ),
            DateTimePicker(
              labelText: "Time",
              selectDate: _onDateChanged,
              selectTime: _onTimeChanged,
            ),
            TextField(
              controller: _locationController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                fillColor: Color.fromRGBO(0, 0, 0, 0),
                labelText: 'Location',
              )
            ),
            Container(
              height: 100,
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(0, 0, 0, 0),
                  labelText: 'Description',
                )
              ),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () => _sendTagStun(context),
              )
            )
          ],
        )
      )
    );
  }

  void _onDateChanged(DateTime date) {
    _currentDate = date;
    _recalculateTimeStamp();
  }

  void _onTimeChanged(TimeOfDay time) {
    _currentTime = time;
    _recalculateTimeStamp();
  }
  void _recalculateTimeStamp() {
    _totalDate = DateTime(
      _currentDate.year,
      _currentDate.month,
      _currentDate.day,
      _currentTime.hour,
      _currentTime.minute
    );
  }

  Future _sendTagStun(BuildContext context) async {
    print("Time in pieces: ${_currentTime.hour}:${_currentTime.minute}");
    print("ISO: ${_totalDate.toIso8601String()} ${_totalDate.timeZoneName}");
    List<dynamic> response = await _loadingDialogManager.performLoadingTask(
        context,
        _apiManager.stunOrTag(
            _codeController.text,
            _totalDate.millisecondsSinceEpoch~/1000,
            _locationController.text,
            _descriptionController.text),
            () => Utilities.showErrorDialog(context, 'An application error occured. Please contact the HvZ moderator team'));

    if (response == null) {
      return; // error happened above
    }
    if (response[0] == 200) {
      String actionString;
      if (_playerInfo.roleChar == 'H')
        actionString = "stunned";
      else
        actionString = "tagged";
      Utilities.showSuccessDialog(context, "Successfully $actionString player ${response[1]}");
    } else if (response[0] == 409) {
      Utilities.showErrorDialog(context, "A duplicate stun already exists!");
    } else {
      if (response[1].isNotEmpty)
        Utilities.showErrorDialog(context, response[1]);
      else
        Utilities.showErrorDialog(context, "An error has occured. Please contact the HVZ mod team for more details.");
    }
  }
}