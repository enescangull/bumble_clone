import 'package:bumble_clone/data/models/match_model.dart';
import 'package:equatable/equatable.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<MatchModel> matches;

  const MatchLoaded(this.matches);

  @override
  List<Object> get props => [matches];
}

class MatchesLoaded extends MatchState {
  final List<MatchModel> unmessagedMatches;
  final List<MatchModel> messagedMatches;

  const MatchesLoaded(this.unmessagedMatches, this.messagedMatches);
}

class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);

  @override
  List<Object> get props => [message];
}
