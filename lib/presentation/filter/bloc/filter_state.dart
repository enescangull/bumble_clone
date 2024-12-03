import 'package:bumble_clone/data/models/preferences_model.dart';

abstract class FilterState {}

class FiltersInitial extends FilterState {}

class FiltersLoading extends FilterState {}

class FiltersLoaded extends FilterState {
  final PreferencesModel preferencesModel;

  FiltersLoaded({required this.preferencesModel});
}

class FiltersFailure extends FilterState {
  final String message;

  FiltersFailure(this.message);
}

class SetUserPreferencesSuccess extends FilterState {}
