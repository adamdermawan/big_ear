abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String message;
  UserLoaded(this.message);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
