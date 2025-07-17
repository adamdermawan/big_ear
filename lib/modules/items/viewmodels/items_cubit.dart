import 'package:flutter_bloc/flutter_bloc.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void loadItems() async {
    emit(ItemsLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      emit(ItemsLoaded("This is Items Page Still in Construction"));
    } catch (e) {
      emit(ItemsError("Failed to load..."));
    }
  }
}
