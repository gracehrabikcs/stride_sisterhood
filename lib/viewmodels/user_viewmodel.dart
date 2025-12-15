import 'package:flutter/material.dart';
import 'package:stride_sisterhood/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(AppUser updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }
}
