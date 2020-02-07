import 'dart:io';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/constants.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class APIManager {
  static final APIManager _singleton = APIManager._internal();

  String hvzUrl;
  Dio dio = Dio();
  PersistCookieJar cj;
  ApplicationData appData = ApplicationData();

  factory APIManager() {
    return _singleton;
  }

  APIManager._internal() {
    if (kReleaseMode) {
      hvzUrl = Constants.PRODUCTION_URL;
    } else {
      hvzUrl = Constants.TESTING_URL;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  Future<String> setCookieJarInterceptor() async {
    Directory dir = await _localCoookieDirectory;
    final cookiePath = dir.path;
    cj = PersistCookieJar(dir: cookiePath);
    dio.interceptors.add(CookieManager(cj));
    return cookiePath;
  }

  Future<int> login(String username, String password) async {
    String loginUrl = hvzUrl + "auth/login/";
    Response response = await dio.post(
        loginUrl,
        data: {
          "username": username,
          "password": password,
        },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
      )
    );
    if (response.statusCode != 200) {
      return response.statusCode;
    }

    var responseCode = await getAccountInfo();

    return responseCode;
  }

  Future<int> getAccountInfo() async {
    Response response = await dio.get(hvzUrl + "account_info",
        options: Options(
          //followRedirects: false,
            validateStatus: (status) { return status < 500; }
        )
    );

    if (response.statusCode == 200) {
      PlayerInfo info = PlayerInfo.fromJson(response.data);
      setUserData(info);
      developer.log("Data processing success.", name: "hvzapilogin");
    } else {
      developer.log("Error processing data " + response.statusCode.toString(), name: "hvzapilogin");
    }
    return response.statusCode;
  }

  void setUserData(PlayerInfo info) {
    if (info == null) {
      developer.log("Info is null", name: "hvzapilogin");
      return;
    } else if (appData.info == null) {
      developer.log("AppData info is null", name: "hvzapilogin");
      return;
    }

    appData.info = info;
    appData.loggedIn = true;
  }

  Future<int> logout() async {
    if (cj != null) {
      List<Cookie> cookies = cj.loadForRequest(Uri.parse(hvzUrl));
      developer.log(cookies.length.toString(), name: "APIManager logout");
    } else {
      developer.log("Cookie Jar is null", name: "APIManager logout");
    }
    Response response = await dio.get(hvzUrl + "auth/logout/",
      options: Options(
        responseType: ResponseType.plain,
      )
    );

    return response.statusCode;
  }

  bool checkCookieExpiration() {
    if (cj == null) {
      developer.log("Null cookie jar", name: "APIManager");
      return true;
    } // if there's no cookie jar, treat it as a fresh login
    List<Cookie> savedCookies = cj.loadForRequest(Uri.parse(hvzUrl));
    if (savedCookies.length < 2) return true;
    bool expired = savedCookies.fold(true, (previous, cookie) => cookie.expires.isBefore(DateTime.now()) && previous);
    return expired;
  }
}