import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  HabitTile({required this.habit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(habit.name),
      subtitle: Text('${habit.descricao} - Frequência: ${habit.frequencia.name}'),
      trailing: Checkbox(
        value: habit.isActive,
        onChanged: (value) {
          // Adicione a lógica para atualizar o status do hábito
        },
      ),
    );
  }
}
