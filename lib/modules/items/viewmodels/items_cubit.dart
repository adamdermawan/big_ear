// lib/modules/items/viewmodels/items_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_ear/modules/items/services/springbed_item_service.dart';
import '../models/spring_bed_item.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final SpringBedItemService _itemService = SpringBedItemService();

  ItemsCubit() : super(ItemsInitial());

  void loadItems() async {
    try {
      emit(ItemsLoading());
      
      // Use real API instead of mock data
      final List<SpringBedItem> items = await _itemService.getAllItemsWithReviews();
      
      // Simulate a small delay for better UX (optional)
      await Future.delayed(const Duration(milliseconds: 300));
      
      emit(ItemsLoaded(items: items));
    } catch (e) {
      emit(ItemsError('Failed to load items: $e'));
    }
  }

  // NEW: Method to refresh items
  void refreshItems() async {
    loadItems();
  }

  // NEW: Method to get a specific item by ID
  void loadItemById(int itemId) async {
    try {
      emit(ItemsLoading());
      
      final SpringBedItem? item = await _itemService.getItemByIdWithReviews(itemId);
      
      if (item != null) {
        emit(ItemsLoaded(items: [item]));
      } else {
        emit(ItemsError('Item not found'));
      }
    } catch (e) {
      emit(ItemsError('Failed to load item: $e'));
    }
  }
}