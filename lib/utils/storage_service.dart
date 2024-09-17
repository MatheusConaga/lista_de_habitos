import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:monitoramento_de_habitos/models/habit_model.dart';

class StorageUtils {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/habits.json');
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final file = await _getLocalFile();
    String jsonString = jsonEncode(habits.map((h) => h.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  Future<List<Habit>> loadHabits() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];
      List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Habit.fromJson(json)).toList();
    } catch (e) {
      print('Error loading habits: $e');
      return [];
    }
  }
}
