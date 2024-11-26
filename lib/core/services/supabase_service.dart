import 'package:bumble_clone/common/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  late final SupabaseClient client;

  SupabaseService._internal();

  static final SupabaseService instance = SupabaseService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: Constants.supabaseUrl,
      anonKey: Constants.supabaseAnonKey,
    );
    client = Supabase.instance.client;
  }
}
