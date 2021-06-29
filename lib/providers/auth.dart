import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import '../models/http_exeption.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  // ignore: unused_field
  String _token;
  // ignore: unused_field
  DateTime _expiryDate;
  // ignore: unused_field
  String _userId;
  // ignore: unused_field
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC03Y860hou0EROIecqsWLxNA7Mesf7vOA';
    try {
      final response = await https.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpExeption(responsedata['error']['message']);
      }

      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
    //print(json.decode(response.body));
  }

  // ignore: missing_return
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    _userId = extractedUserData['userId'];

    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () => logOut());
  }
}
