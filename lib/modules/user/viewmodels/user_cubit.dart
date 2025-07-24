import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial()) {
    // Check for a saved user session when the app starts
    _loadUser();
  }

  static const String _userKey = 'loggedInUser';

  /// Attempts to load a user from local storage.
  Future<void> _loadUser() async {
    emit(UserLoading());
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading

    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      try {
        final userData = jsonDecode(userDataString);
        final user = User.fromJson(userData);
        emit(UserAuthenticated(user));
      } catch (e) {
        // If data is corrupt, clear it and go to initial state
        await _removeUser();
        emit(UserInitial());
      }
    } else {
      // No user saved, start fresh
      emit(UserInitial());
    }
  }

  /// Saves user data to local storage.
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Removes user data from local storage.
  Future<void> _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Logs in a user with email and password.
  void login(String email, String password) async {
    emit(UserLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // --- Mock Credentials ---
    const String correctEmail = "siti.lala@gmail.com";
    const String correctPassword = "sitilala@123";

    if (email.trim().toLowerCase() == correctEmail && password == correctPassword) {
      final mockUser = User(email: email, name: "Siti Lala");
      await _saveUser(mockUser); // Save user on successful login
      emit(UserAuthenticated(mockUser));
    } else {
      emit(UserError("Invalid email or password."));
    }
  }

  /// Logs in a user as a guest.
  void loginAsGuest() async {
    emit(UserLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    await _removeUser(); // Ensure no previous user is saved
    emit(UserGuest());
  }

  /// Logs the current user out.
  void logout() async {
    await _removeUser();
    emit(UserInitial());
  }
}