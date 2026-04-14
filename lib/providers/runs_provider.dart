import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/zakat_run.dart';

const _boxName = 'zakat_runs';
const _maxRuns = 30;

class RunsNotifier extends StateNotifier<List<ZakatRun>> {
  RunsNotifier() : super([]) {
    _load();
  }

  Box<ZakatRun>? _box;

  Future<void> _load() async {
    _box = Hive.box<ZakatRun>(_boxName);
    final runs = _box!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = runs;
  }

  /// Returns true if saved successfully.
  /// Returns false if at cap — caller must prompt deletion.
  Future<bool> saveRun(ZakatRun run) async {
    _box ??= Hive.box<ZakatRun>(_boxName);
    if (state.length >= _maxRuns) return false;
    await _box!.put(run.id, run);
    final runs = _box!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = runs;
    return true;
  }

  Future<void> deleteOldestAndSave(ZakatRun run) async {
    _box ??= Hive.box<ZakatRun>(_boxName);
    final sorted = _box!.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (sorted.isNotEmpty) {
      await sorted.first.delete();
    }
    await _box!.put(run.id, run);
    final runs = _box!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = runs;
  }

  Future<void> deleteRun(String id) async {
    _box ??= Hive.box<ZakatRun>(_boxName);
    await _box!.delete(id);
    state = state.where((r) => r.id != id).toList();
  }

  ZakatRun? findById(String id) {
    try {
      return state.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}

final runsProvider = StateNotifierProvider<RunsNotifier, List<ZakatRun>>(
  (ref) => RunsNotifier(),
);
