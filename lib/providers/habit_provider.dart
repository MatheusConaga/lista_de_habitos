import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) => HabitNotifier());

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier() : super([]);

  void addHabit(Habit habit) {
    state = [...state, habit];
  }

  void removeHabit(Habit habit) {
    state = state.where((h) => h.id != habit.id).toList();
  }

  void markHabitAsCompleted(Habit updatedHabit) {
    state = state.map((h) {
      if (h.id == updatedHabit.id) {
        return updatedHabit;
      } else {
        return h;
      }
    }).toList();
  }
}
