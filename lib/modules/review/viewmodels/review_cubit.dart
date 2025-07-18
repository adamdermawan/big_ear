import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_state.dart';
import 'package:big_ear/core/network/mock_up_api.dart';
import '../../shared/models/spring_bed_item.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  void loadReview() async {
    emit(ReviewLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      final items = springBed.map((e) => SpringBedItem.fromJson(e)).toList();
      emit(ReviewLoaded(items));
    } catch (e) {
      emit(ReviewError("Failed to load..."));
    }
  }
}
