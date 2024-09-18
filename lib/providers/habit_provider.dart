import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';

// Definindo o estado inicial como uma lista vazia de hábitos
class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier() : super([]);

  void addHabit(Habit habit) {
    state = [...state, habit];
  }

  void updateHabit(Habit updatedHabit) {
    state = [
      for (final habit in state)
        if (habit.id == updatedHabit.id) updatedHabit else habit
    ];
  }

  void removeHabit(Habit habit) {
    state = state.where((h) => h.id != habit.id).toList();
  }

  void markHabitAsCompleted(Habit habit) {
    state = [
      for (final h in state)
        if (h.id == habit.id) habit.copyWith(isCompleted: true) else h
    ];
  }
}

// Provider para o estado dos hábitos
final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier();
});
