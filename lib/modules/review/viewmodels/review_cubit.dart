import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  void loadReview() async {
    emit(ReviewLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      emit(ReviewLoaded("This is Review Page Still in Construction"));
    } catch (e) {
      emit(ReviewError("Failed to load..."));
    }
  }
}
