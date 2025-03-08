import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bumble_clone/core/services/match_service.dart';
import '../../../data/models/match_model.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchService matchService;

  MatchBloc(this.matchService) : super(MatchInitial()) {
    on<LoadMatches>((event, emit) async {
      emit(MatchLoading());
      try {
        final List<MatchModel>? matches = await matchService.fetchMatches();
        final unmessagedMatches = <MatchModel>[];
        final messagedMatches = <MatchModel>[];
        if (matches != null) {
          for (var match in matches) {
            if (await matchService.hasMessages(match.id)) {
              messagedMatches.add(match);
            } else {
              unmessagedMatches.add(match);
            }
          }
        }
        emit(MatchesLoaded(unmessagedMatches, messagedMatches));
      } catch (e) {
        emit(MatchError(e.toString()));
      }
    });
  }
}
