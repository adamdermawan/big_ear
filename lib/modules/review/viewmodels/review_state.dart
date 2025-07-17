abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final String message;
  ReviewLoaded(this.message);
}

class ReviewError extends ReviewState {
  final String error;
  ReviewError(this.error);
}
