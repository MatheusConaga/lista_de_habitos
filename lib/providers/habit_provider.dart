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
}

final storageServiceProvider = Provider((ref) => StorageService());

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return HabitNotifier(storageService);
});
