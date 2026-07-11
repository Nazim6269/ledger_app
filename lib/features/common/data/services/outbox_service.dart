import 'dart:async';
import 'dart:convert';

import 'package:ledger_app/database/app_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutboxService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  bool _isSyncing = false;

  OutboxService(this._db, this._supabase);

  Future<void> processOutbox() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final items = await _db.getOutboxItems();
      for (final item in items) {
        final data = jsonDecode(item.payload) as Map<String, dynamic>;
        try {
          await _supabase.from(item.tName).insert(data);
          await _db.removeFromOutbox(item.id);
        } catch (e) {
          await _db.incrementRetryCount(item.id);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
