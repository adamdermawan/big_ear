// Abstract state base class
abstract class HomeState {}

// Initial state
class HomeInitial extends HomeState {}

// Loading state
class HomeLoading extends HomeState {}

// Success state
class HomeLoaded extends HomeState {
  final String message;

  HomeLoaded(this.message);
}

// Error state
class HomeError extends HomeState {
  final String error;

  HomeError(this.error);
}
