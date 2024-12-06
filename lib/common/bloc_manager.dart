import 'package:bumble_clone/presentation/navigate/bloc/nav_bloc.dart';
import 'package:bumble_clone/presentation/navigate/bloc/nav_event.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_bloc.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocManager {
  static void resetAll(BuildContext context) {
    context.read<BottomNavBloc>().add(Reset());
    context.read<ProfileBloc>().add(ResetProfile());
  }
}
