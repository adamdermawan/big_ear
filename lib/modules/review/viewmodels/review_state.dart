import '../../shared/models/spring_bed_item.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<SpringBedItem> items;
  ReviewLoaded(this.items);
}

class ReviewError extends ReviewState {
  final String error;
  ReviewError(this.error);
}
