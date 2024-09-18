import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/habitDetailScreen.dart';

class DiarioScreen extends ConsumerWidget {
  const DiarioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitosDiarios = ref.watch(habitProvider).where((habit) => habit.frequencia == Frequencia.diario).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Diários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(),
                ),
              ).then((_) {
                // Atualiza a lista de hábitos após voltar da tela de adicionar/editar
                ref.refresh(habitProvider);
              });
            },
          ),
        ],
      ),
      body: habitosDiarios.isEmpty
          ? Center(child: Text('Nenhum hábito diário encontrado.'))
          : ListView.builder(
        itemCount: habitosDiarios.length,
        itemBuilder: (context, index) {
          final habit = habitosDiarios[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(habitProvider.notifier).removeHabit(habit.id);
              },
            ),
            title: Text(habit.name),
            subtitle: Text(
                '${habit.descricao}\nDias completados: ${habit.completedDays.join(', ')}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddHabitScreen(
                          habit: habit,
                        ),
                      ),
                    ).then((_) {
                      ref.refresh(habitProvider);
                    });
                  },
                ),
                Checkbox(
                  value: habit.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      final now = DateTime.now().day;
                      ref.read(habitProvider.notifier).toggleHabitCompletion(habit.id);
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailScreen(habito: habit),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
