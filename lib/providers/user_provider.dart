import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _username = '';
  String _profilePicture = '';

  String get userId => _userId;
  String get username => _username;
  String get profilePicture => _profilePicture;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? const Uuid().v4();
    _username = prefs.getString('username') ?? '';
    _profilePicture = prefs.getString('profilePicture') ?? '';
    notifyListeners();
  }

  Future<void> setUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }

  Future<void> setProfilePicture(String profilePicture) async {
    _profilePicture = profilePicture;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePicture', profilePicture);
    notifyListeners();
  }
}
