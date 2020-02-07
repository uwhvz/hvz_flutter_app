import 'package:flutter/material.dart';

import 'dart:developer' as developer;

class LoadingDialogManager {
  static final LoadingDialogManager _instance = LoadingDialogManager._internal();

  factory LoadingDialogManager() {
    return _instance;
  }

  LoadingDialogManager._internal();

  Future<T> performLoadingTask<T>(BuildContext context, Future<T> calculation, Function() onError) async {
    _showLoadingDialog(context);
    try {
      T result = await calculation;
      _hideLoadingDialog(context);
      return result;
    }
    catch(e) {
      _hideLoadingDialog(context);
      developer.log("Error: " + e.toString());
      onError();
    }
    _hideLoadingDialog(context);
    return null;
  }

  bool isLoading = false;

  void _showLoadingDialog(BuildContext context) {
    isLoading = true;
    AlertDialog progress = AlertDialog(
        content: Row (
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              CircularProgressIndicator(),
            ]
        )
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return progress;
        }
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    if (isLoading) {
      isLoading = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}