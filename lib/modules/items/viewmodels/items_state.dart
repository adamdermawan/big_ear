import '../../shared/models/spring_bed_item.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<SpringBedItem> items;
  ItemsLoaded(this.items);
}

class ItemsError extends ItemsState {
  final String error;
  ItemsError(this.error);
}
