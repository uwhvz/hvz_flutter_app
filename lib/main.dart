import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvz_flutter_app/loginScreen/login.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';

void main() {
  var apiManager = APIManager();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        apiManager.setCookieJarInterceptor()
          .then((_) {
            runApp(new MyApp());
        });
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UW Humans vs Zombies',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.grey[900],
        accentColor: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
