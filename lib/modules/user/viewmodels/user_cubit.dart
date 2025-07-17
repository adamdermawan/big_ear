import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void loadUser() async {
    emit(UserLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      emit(UserLoaded("This is User Page Still in Construction"));
    } catch (e) {
      emit(UserError("Failed to load..."));
    }
  }
}
