import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Estado global para hábitos
class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier() : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      state = jsonList.map((json) => Habit.fromJson(json)).toList();
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/habitos.txt');
  }

  void addHabit(Habit habit) async {
    state = [...state, habit];
    await _saveHabits();
  }

  void removeHabit(Habit habit) async {
    state = state.where((h) => h.id != habit.id).toList();
    await _saveHabits();
  }

  Future<void> _saveHabits() async {
    final json = state.map((habit) => habit.toJson()).toList();
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(json));
  }
}

// Provedor para acessar e modificar hábitos
final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>(
      (ref) => HabitNotifier(),
);
