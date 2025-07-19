import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void login(String email, String password) async {
    emit(UserLoading());
    await Future.delayed(const Duration(seconds: 1));

    // Simulate login success
    final mockUser = User(email: email, name: "Adam Dermawan");
    emit(UserAuthenticated(mockUser));
  }

  void loginAsGuest() async {
    emit(UserLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(UserGuest());
  }

  void logout() {
    emit(UserInitial());
  }
}
