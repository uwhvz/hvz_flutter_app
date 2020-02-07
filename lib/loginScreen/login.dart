import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/loginScreen/widgets/loginWidget.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/mainScreen/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  final String title = "Login";
  final String routeName = "LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  final loadingDialogManager = LoadingDialogManager();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiManager = APIManager();


  @override
  void initState() {
    super.initState();
    if (!apiManager.checkCookieExpiration()) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _getAccountInfo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LoginWidget(emailController, passwordController, _submit)
    );
  }

  void _getAccountInfo() async {
    int responseCode = await loadingDialogManager.performLoadingTask(
        context,
        apiManager.getAccountInfo(),
        () => null
    );
    if (responseCode == null) return;
    else if (responseCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          ));
    }
  }

  void _submit() async {
    int responseCode = await loadingDialogManager.performLoadingTask(
      context,
      apiManager.login(emailController.text, passwordController.text),
        () => _onError("Caught API error", "Unknown Error. Please contact the HvZ admin for assistance.")
    );

    if (responseCode == null) return;
    _navigateToMainScreen(responseCode);
  }

  _navigateToMainScreen(int responseCode) {
    switch(responseCode) {
      case 200:
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => HomePage()
            ));
        return;
      case 403:
      case 404:
        _showAlertDialog(context, "Invalid Credentials. Please try again.");
        return;
      case 500:
        _showAlertDialog(context, "Interal Server Error. Please contact the HvZ admin for assistance.");
        return;
      default:
        _showAlertDialog(context, "Unknown Error. Please contact the HvZ admin for assistance.");
        return;
    }
  }

  _showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void _onError(String devLog, String alert) {
    _showAlertDialog(context, alert);
  }
}



