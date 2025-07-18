import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_ear/core/network/mock_up_api.dart';
import '../../shared/models/spring_bed_item.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void loadItems() async {
    emit(ItemsLoading());
    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    try {
      final items = springBed.map((e) => SpringBedItem.fromJson(e)).toList();
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError("Failed to load..."));
    }
  }
}
