import 'package:big_ear/modules/items/models/spring_bed_item.dart'; // Import SpringBedItem

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<SpringBedItem> items; // Define the items property

  ItemsLoaded({required this.items});
}

class ItemsError extends ItemsState {
  final String error;

  ItemsError(this.error);
}
