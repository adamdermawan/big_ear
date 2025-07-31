import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart'; // 👈 Import the service
import '../models/user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthService _authService = AuthService(); // 👈 Instantiate the service

  UserCubit() : super(UserInitial()) {
    _loadUser();
  }

  static const String _userKey = 'loggedInUser';
  static const String _tokenKey = 'authToken'; // 👈 For storing the JWT

  Future<void> _saveSession(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, token); // 👈 Save the token
  }
 
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

  void login(String email, String password) async {
    emit(UserLoading());
    try {
      final response = await _authService.login(email, password);
      final user = User.fromJson(response['user']);
      final token = response['token'];

      await _saveSession(user, token); // 👈 Save both user and token
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserError("Invalid email or password. Please try again."));
    }
  }

  /// Registers a new user.
  void register({required String name, required String email, required String password}) async {
    emit(UserLoading());
    try {
      final response = await _authService.register(name: name, email: email, password: password);
      final user = User.fromJson(response['user']);
      final token = response['token'];

      await _saveSession(user, token);
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserError("Registration failed. Email might be taken."));
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