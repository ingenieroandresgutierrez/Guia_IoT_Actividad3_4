import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../models/pot_reading.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  final SupabaseClient _client = Supabase.instance.client;

  Stream<PotReading> potStream() {
    return _client
        .from('pot_readings')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .order('created_at', ascending: false)
        .limit(1)
        .map((rows) {
      if (rows.isEmpty) {
        throw Exception('No hay lecturas disponibles.');
      }
      return PotReading.fromMap(rows.first);
    });
  }

  Future<bool> getLedState() async {
    final data = await _client
        .from('led_control')
        .select('led_on')
        .eq('device_id', deviceId)
        .maybeSingle();

    return (data?['led_on'] as bool?) ?? false;
  }

  Future<bool> setLedState(bool value) async {
    final updated = await _client
        .from('led_control')
        .update({'led_on': value})
        .eq('device_id', deviceId)
        .select('led_on')
        .maybeSingle();

    return (updated?['led_on'] as bool?) ?? value;
  }
}
