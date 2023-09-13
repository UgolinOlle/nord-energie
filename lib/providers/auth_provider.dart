import 'package:flutter/cupertino.dart';
import 'package:mobile/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAdmin = false;

  UserModel? get user => _user;
  bool get isAdmin => _isAdmin;

  void setUser(UserModel user) {
    _user = user;
    _updateIsAdmin();
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }

  void _updateIsAdmin() {
    _isAdmin = (_user?.role == 'Admin');
  }
}
