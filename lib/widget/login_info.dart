import 'package:flutter/cupertino.dart';

/// The login information.
class LoginInfo extends ChangeNotifier {
  /// The username of login.
  String get userName => _userName;
  String _userName = '';
  bool _toSetting = false;
  bool _toReg = false;

  /// Whether a user has logged in.
  bool get loggedIn => _userName.isNotEmpty;
  bool get toSetting => _toSetting;
  bool get toReg => _toReg;

  Object _tcpInfo = {};

  Object get tcpInfo => _tcpInfo;

  void setTcpInfo(Object obj) {
    _tcpInfo = obj;
    notifyListeners();
  }

  /// Logs in a user.
  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setting(bool yes) {
    _toSetting = yes;
    notifyListeners();
  }

  void reg(bool yes) {
    _toReg = yes;
    notifyListeners();
  }

  /// Logs out the current user.
  void logout() {
    _userName = '';
    notifyListeners();
  }
}
