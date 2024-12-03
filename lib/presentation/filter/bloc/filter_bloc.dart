import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/preference_repository.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final PreferenceRepository _preferenceRepository = PreferenceRepository();

  FilterBloc() : super(FiltersInitial()) {
    on<GetFilterParameters>((event, emit) async {
      emit(FiltersLoading());
      try {
        final preferences = await _preferenceRepository.fetchPreferences();

        emit(FiltersLoaded(preferencesModel: preferences));
      } catch (e) {
        emit(FiltersFailure("Failed to load preferences"));
      }
    });

    on<UpdatePreferences>(
      (event, emit) async {
        try {
          final preferences = _preferenceRepository.updatePreferences(
              ageMax: event.ageMax,
              ageMin: event.ageMin,
              distance: event.distance,
              preferredGender: event.preferredGender);
        } catch (e) {}
      },
    );
  }
  @override
  void onTransition(Transition<FilterEvent, FilterState> transition) {
    super.onTransition(transition);
    print("Transition: $transition");
  }
}
