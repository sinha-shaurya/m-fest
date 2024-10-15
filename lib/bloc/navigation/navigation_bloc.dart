import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationHome()) {
    on<PageTapped>((event, emit) {
      switch (event.index) {
        case 0:
          emit(NavigationHome());
          break;
        case 1:
          emit(NavigationCategories());
          break;
        case 2:
          emit(NavigationCoupon());
          break;
        case 3:
          emit(NavigationProfile());
          break;
      }
    });
  }
}
