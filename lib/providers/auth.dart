import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

/// Provider class for handling authentication.
class Auth with ChangeNotifier {
  /// User token for authentication on web server.
  String _token;

  /// Expiry date of the token.
  DateTime _expiryDate;

  /// User's unique ID on the web server.
  String _userId;

  /// Timer that counts down to token expiry.
  Timer _authTimer;

  /// Method to handle the HTTP request for authentiation
  /// to the web server.
  ///
  /// Handles both login and sign up, depending on the [urlNoAPIKey] that
  /// is passed in. Credentials are [email] and [password].
  Future<void> _authenticate(
      String email, String password, String urlNoAPIKey) async {
    const api_key = String.fromEnvironment('FIREBASE_API_KEY');
    final url = urlNoAPIKey + api_key;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      // start logout timer
      _autoLogout();

      notifyListeners();

      // store login data in local storage/shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      // throw through to widget
      throw error;
    }
  }

  /// Returns a boolean value of true if the user
  /// is authenticated/logged in.
  bool get isAuth {
    return token != null;
  }

  /// Returns the [token] for this user, if the user
  /// has a [token], else returns null.
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  /// Returns the [userId] for this user.
  String get userId {
    return _userId;
  }

  /// Method for signing up a user with [email] and [password]
  /// as their credentials.
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=');
  }

  /// Method for loggin in a user with [email] and [password] as their credentials.
  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=');
  }

  /// Method checking if the user is already logged in.
  ///
  /// Returns true if user has valid credentials saved in Shared Preferences/local storage,
  /// otherwise returns false,
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    // check if token has expired
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;

    // initialize values
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return true;
  }

  /// Method to logout the user on this device.
  ///
  /// Removes the user's credentials stored in SharedPreferences,
  /// or local storage. Cancels countdown timer for expiry logout.
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) _authTimer.cancel();

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData);
    // purge all app data
    prefs.clear();
  }

  /// Automatically logs out user once their [token] expires, meaning
  /// that the [_authTimer] has expired.
  void _autoLogout() {
    // cancel any existing timer
    if (_authTimer != null) _authTimer.cancel();

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
