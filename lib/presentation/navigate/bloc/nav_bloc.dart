import 'package:flutter_bloc/flutter_bloc.dart';

import 'nav_event.dart';
import 'nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitial(1)) {
    on<BottomNavItemSelected>((event, emit) {
      emit(BottomNavInitial(event.index));
    });
  }
}
