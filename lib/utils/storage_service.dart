import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:monitoramento_de_habitos/models/habit.dart';

class StorageService {
  static const String habitKey = 'habits_key';

  // Salvar lista de hábitos
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedHabits = habits.map((habit) => jsonEncode(habit.toJson())).toList();
    await prefs.setStringList(habitKey, encodedHabits);
  }

  // Carregar lista de hábitos
  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedHabits = prefs.getStringList(habitKey);
    if (encodedHabits != null) {
      return encodedHabits.map((habitStr) => Habit.fromJson(jsonDecode(habitStr))).toList();
    }
    return [];
  }
}
