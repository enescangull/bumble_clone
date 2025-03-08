import 'package:bumble_clone/common/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  late final SupabaseClient client;

  SupabaseService._internal();

  static final SupabaseService instance = SupabaseService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: SupaBase.supabaseUrl,
      anonKey: SupaBase.supabaseAnonKey,
      debug: true,
    );
    client = Supabase.instance.client;
  }
}
