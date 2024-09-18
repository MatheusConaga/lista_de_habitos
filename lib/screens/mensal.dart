import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart'; // Importe a tela de adicionar/editar hábito
import 'package:monitoramento_de_habitos/screens/habitDetailScreen.dart'; // Importe a tela de detalhes

class MensalScreen extends ConsumerWidget {
  const MensalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitosMensais = ref.watch(habitProvider).where((habit) => habit.frequencia == Frequencia.mensal).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Mensais'),
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
      body: habitosMensais.isEmpty
          ? Center(child: Text('Nenhum hábito mensal encontrado.'))
          : ListView.builder(
        itemCount: habitosMensais.length,
        itemBuilder: (context, index) {
          final habit = habitosMensais[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(habitProvider.notifier).removeHabit(habit); // Remove o hábito
              },
            ),
            title: Text(habit.name),
            subtitle: Text(
                '${habit.descricao}\nDias do mês: ${habit.days.join(', ')}\nDias completados: ${habit.completedDays.join(', ')}'
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
                    );
                  },
                ),
                Checkbox(
                  value: habit.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      final now = DateTime.now().day;
                      ref.read(habitProvider.notifier).markHabitAsCompleted(
                        habit.copyWith(
                          isCompleted: value,
                          completedDays: value
                              ? [...habit.completedDays, now] // Adiciona o dia atual se o hábito estiver completo
                              : habit.completedDays.where((day) => day != now).toList(), // Remove o dia atual se o hábito não estiver completo
                        ),
                      );
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
