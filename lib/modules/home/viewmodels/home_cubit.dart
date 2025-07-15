import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHome() async {
    emit(HomeLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      // Simulate a successful result
      emit(HomeLoaded("Welcome Guest.."));
    } catch (e) {
      emit(HomeError("Gagal Boss..."));
    }
  }
}
