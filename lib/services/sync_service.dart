import 'package:connectivity_plus/connectivity_plus.dart';
import 'storage_service.dart';
import 'supabase_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final SupabaseService _supabase = SupabaseService();
  final StorageService _storage = StorageService();

  Future<void> syncData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult != ConnectivityResult.none) {
      // Tentar sincronizar dados pendentes
      final pendingData = await _storage.getOfflineData('pending_sync');
      if (pendingData != null) {
        try {
          // Sincronizar tentativas de quiz
          final quizResults = pendingData['quiz_results'] as List?;
          if (quizResults != null) {
            for (final result in quizResults) {
              await _supabase.saveQuizAttempt(result);
            }
          }
          
          // Limpar dados sincronizados
          await _storage.saveOfflineData('pending_sync', {});
        } catch (e) {
          print('Erro na sincronização: $e');
        }
      }
    }
  }
}