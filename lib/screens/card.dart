import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:intl/intl.dart'; // Para obter o dia e o mês atual

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final today = DateTime.now();
    final day = today.day;
    final month = today.month;

    // Filtra os hábitos que têm a frequência diária ou semanal e caem no dia atual
    final todayHabits = habits.where((habit) {
      if (habit.frequencia == Frequencia.diario) {
        return true;
      } else if (habit.frequencia == Frequencia.semanal) {
        return habit.days.contains(today.weekday);
      } else if (habit.frequencia == Frequencia.mensal) {
        return habit.days.contains(day);
      }
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento de Hábitos'),
      ),
      body: Column(
        children: [
          // Se houver tarefas para o dia, exiba o Card
          if (todayHabits.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.amber,
                child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text('Tarefas de hoje'),
                  subtitle: Text('Você tem ${todayHabits.length} tarefas para completar.'),
                  onTap: () {
                    // Navega para a lista de hábitos ou outra tela relevante
                    // Aqui você pode abrir uma tela específica para exibir os hábitos
                  },
                ),
              ),
            ),
          // Exibe a lista de hábitos ou outra interface abaixo
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return ListTile(
                  title: Text(habit.name),
                  subtitle: Text('Frequência: ${habit.frequencia.toString()}'),
                  trailing: Checkbox(
                    value: habit.isCompleted,
                    onChanged: (bool? value) {
                      ref.read(habitProvider.notifier).toggleHabitCompletion(habit.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
