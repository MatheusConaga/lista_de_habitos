import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart'; // Importe a tela de adicionar/editar hábito
import 'package:monitoramento_de_habitos/screens/habitDetailScreen.dart'; // Importe a tela de detalhes

class SemanalScreen extends ConsumerWidget {
  const SemanalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém a lista de hábitos com frequência semanal
    final habitosSemana = ref.watch(habitProvider).where((habit) => habit.frequencia == Frequencia.semanal).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Semanais'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(), // Navega para a tela de adicionar
                ),
              );
            },
          ),
        ],
      ),
      body: habitosSemana.isEmpty
          ? Center(child: Text('Nenhum hábito semanal encontrado.'))
          : ListView.builder(
        itemCount: habitosSemana.length,
        itemBuilder: (context, index) {
          final habit = habitosSemana[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(habitProvider.notifier).removeHabit(habit.id); // Remove o hábito usando o ID
              },
            ),
            title: Text(habit.name),
            subtitle: Text(
                '${habit.descricao}\nDias completados: ${habit.completedDays.join(', ')}'
            ), // Mostra os dias completados
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Navega para a tela de adicionar/editar hábito
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddHabitScreen(
                          habit: habit, // Passa o hábito para a tela de adicionar/editar
                        ),
                      ),
                    ).then((_) {
                      // Atualiza a tela após a edição do hábito
                      ref.refresh(habitProvider);
                    });
                  },
                ),
                Checkbox(
                  value: habit.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      ref.read(habitProvider.notifier).toggleHabitCompletion(habit.id); // Usa o ID do hábito
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              // Navega para a tela de detalhes do hábito
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailScreen(habito: habit), // Passa o hábito para a tela de detalhes
                ),
              );
            },
          );
        },
      ),
    );
  }
}
