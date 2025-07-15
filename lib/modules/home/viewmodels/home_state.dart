abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String message;
  HomeLoaded(this.message);
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}
