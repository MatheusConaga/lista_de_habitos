import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/utils/storage_service.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  final StorageService _storageService;

  HabitNotifier(this._storageService) : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    state = await _storageService.loadHabits();
  }

  void addHabit(Habit habit) {
    state = [...state, habit];
    _saveHabits();
  }

  void removeHabit(String id) {
    state = state.where((habit) => habit.id != id).toList();
    _saveHabits();
  }

  void removeHabits(List<String> ids) {
    state = state.where((habit) => !ids.contains(habit.id)).toList();
    _saveHabits();
  }

  void toggleHabitCompletion(String id) {
    state = state.map((habit) {
      if (habit.id == id) {
        return habit.copyWith(isCompleted: !habit.isCompleted);
      }
      return habit;
    }).toList();
    _saveHabits();
  }

  Future<void> _saveHabits() async {
    await _storageService.saveHabits(state);
  }

  List<Habit> getTodayHabits(DateTime today) {
    final day = today.day;
    return state.where((habit) {
      if (habit.frequencia == Frequencia.diario) {
        return true;
      } else if (habit.frequencia == Frequencia.semanal) {
        // Verifica se o hábito semanal deve ser realizado no dia da semana atual
        return habit.days.contains(today.weekday);
      } else if (habit.frequencia == Frequencia.mensal) {
        // Verifica se o hábito mensal deve ser realizado no dia do mês atual
        return habit.days.contains(day);
      }
      return false;
    }).toList();
  }
}


final storageServiceProvider = Provider((ref) => StorageService());

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return HabitNotifier(storageService);
});

final reminderCardProvider = StateProvider<bool>((ref) => false);

final reminderLogicProvider = Provider<void>((ref) {
  final habitNotifier = ref.watch(habitProvider.notifier);
  final reminderCard = ref.watch(reminderCardProvider.notifier);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final today = DateTime.now();
    final todayHabits = habitNotifier.getTodayHabits(today);
    reminderCard.state = todayHabits.isNotEmpty;
  });
});
//MUDEI