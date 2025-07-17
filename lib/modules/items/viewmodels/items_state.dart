abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final String message;
  ItemsLoaded(this.message);
}

class ItemsError extends ItemsState {
  final String error;
  ItemsError(this.error);
}
