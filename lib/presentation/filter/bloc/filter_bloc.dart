import 'package:bumble_clone/core/exceptions/app_exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/preference_repository.dart';
import 'filter_event.dart';
import 'filter_state.dart';

/// Filtreleme işlemlerini yöneten BLoC sınıfı.
///
/// Bu sınıf, kullanıcı tercihlerinin alınması ve güncellenmesi gibi
/// filtreleme işlemlerini yönetir.
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final PreferenceRepository _preferenceRepository;

  /// FilterBloc sınıfının constructor'ı.
  ///
  /// [_preferenceRepository] parametresi, tercih işlemlerini gerçekleştiren repository'yi alır.
  FilterBloc(this._preferenceRepository) : super(FiltersInitial()) {
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
        emit(FiltersLoading());
        try {
          await _preferenceRepository.updatePreferences(
              ageMax: event.ageMax,
              ageMin: event.ageMin,
              distance: event.distance,
              preferredGender: event.preferredGender);
          emit(PreferencesUpdated());
        } catch (e) {
          if (e is AppException) {
            emit(FiltersFailure(e.message));
          } else {
            emit(FiltersFailure(e.toString()));
          }
        }
      },
    );
  }
}
