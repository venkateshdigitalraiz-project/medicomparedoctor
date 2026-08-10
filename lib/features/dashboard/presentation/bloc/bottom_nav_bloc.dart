import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/dashboard/presentation/bloc/bottom_nav_event.dart';
import 'package:medicompare/features/dashboard/presentation/bloc/bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState()) {
    on<ChangeTab>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}
