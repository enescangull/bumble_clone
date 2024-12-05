import 'package:bumble_clone/presentation/navigate/bloc/nav_bloc.dart';
import 'package:bumble_clone/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/routes.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/filter/bloc/filter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => FilterBloc()),
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(create: (context) => ProfileBloc()),
      BlocProvider(create: (context) => BottomNavBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      title: 'Bumble Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.login,
    );
  }
}
