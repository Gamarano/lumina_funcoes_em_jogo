import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static const String _url = 'SUA_SUPABASE_URL';
  static const String _anonKey = 'SUA_SUPABASE_ANON_KEY';

  late final SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
    client = Supabase.instance.client;
  }

  // Métodos para usuários
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await client
        .from('users')
        .upsert(profile)
        .execute();
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from('users')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    
    return response.data;
  }

  // Métodos para ranking
  Future<List<Map<String, dynamic>>> getGlobalRanking() async {
    final response = await client
        .from('users')
        .select('name, school, total_points, updated_at')
        .order('total_points', ascending: false)
        .limit(100)
        .execute();
    
    return List<Map<String, dynamic>>.from(response.data ?? []);
  }

  // Métodos para histórico
  Future<void> saveQuizAttempt(Map<String, dynamic> attempt) async {
    await client
        .from('quiz_attempts')
        .insert(attempt)
        .execute();
  }
}