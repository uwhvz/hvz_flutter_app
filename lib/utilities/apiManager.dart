import 'dart:io';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hvz_flutter_app/constants/apiConstants.dart';
import 'package:hvz_flutter_app/constants/constants.dart';
import 'package:hvz_flutter_app/models/player/playerInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class APIManager {
  static final APIManager _singleton = APIManager._internal();

  String _hvzUrl;
  Dio _dio = Dio();
  PersistCookieJar _cj;
  ApplicationData _appData = ApplicationData();

  factory APIManager() {
    return _singleton;
  }

  APIManager._internal() {
    if (kReleaseMode) {
      _hvzUrl = Constants.PRODUCTION_URL;
    } else {
      _hvzUrl = Constants.TESTING_URL;
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
    _cj = PersistCookieJar(dir: cookiePath);
    _dio.interceptors.add(CookieManager(_cj));
    return cookiePath;
  }

  Future<int> login(String username, String password) async {
    String loginUrl = _hvzUrl + ApiConstants.login;
    Response response = await _dio.post(
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
    Response response = await _dio.get(_hvzUrl + ApiConstants.account_info,
        options: Options(
          //followRedirects: false,
            validateStatus: (status) { return status < 500; }
        )
    );

    if (response.statusCode == 200) {
      PlayerInfo info = PlayerInfo.fromJson(response.data);
      setUserData(info);
    }
    return response.statusCode;
  }

  void setUserData(PlayerInfo info) {
    if (info == null || _appData.info == null) {
      return;
    }

    _appData.info = info;
    _appData.loggedIn = true;
  }

  Future<int> logout() async {
    Response response = await _dio.get(_hvzUrl + ApiConstants.logout,
      options: Options(
        responseType: ResponseType.plain,
      )
    );

    return response.statusCode;
  }

  Future<List<dynamic>> stunOrTag(String code, int time, String location, String description) async {
    Map<String, dynamic> data = {
      "code": code,
      "time": time,
    };

    if (location != null && location.isNotEmpty) data["location"] = location;
    if (description != null && description.isNotEmpty) data["description"] = description;

    List<Cookie> cookies = List();
    Cookie csrf;
    if (_cj != null) {
      List<Cookie> cookies = _cj.loadForRequest(Uri.parse(_hvzUrl));
      csrf = cookies.firstWhere((element) => element.name == "csrftoken", );
    } else {
      csrf = Cookie("", "");
    }
    Response response = await _dio.post(_hvzUrl + ApiConstants.stun_tag,
      data: data,
      options: Options(
        headers: {
          "X-CSRFToken" : csrf.value
        },
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) { return status < 500; }
      )
    );

    return [response.statusCode, response.data];
  }

  bool checkCookieExpiration() {
    if (_cj == null) {
      developer.log("Null cookie jar", name: "APIManager");
      return true;
    } // if there's no cookie jar, treat it as a fresh login
    List<Cookie> savedCookies = _cj.loadForRequest(Uri.parse(_hvzUrl));
    if (savedCookies.length < 2) return true;
    bool expired = savedCookies.fold(true, (previous, cookie) => cookie.expires.isBefore(DateTime.now()) && previous);
    return expired;
  }
}