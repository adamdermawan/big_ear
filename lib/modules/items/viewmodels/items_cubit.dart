import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_ear/core/network/mock_up_api.dart';
import '../models/spring_bed_item.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void loadItems() async {
    try {
      emit(ItemsLoading());
      // Use the new helper function to get items with calculated ratings and reviews
      final List<SpringBedItem> items = getSpringBedItemsWithReviews();
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      emit(ItemsLoaded(items: items));
    } catch (e) {
      emit(ItemsError('Failed to load items: $e'));
    }
  }
}
