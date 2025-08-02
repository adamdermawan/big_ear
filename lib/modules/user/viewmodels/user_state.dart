import '../models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAuthenticated extends UserState {
  final User user;
  UserAuthenticated(this.user);
}

class UserGuest extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserPasswordChanged extends UserState {}