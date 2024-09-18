import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class SemanalScreen extends ConsumerWidget {
  const SemanalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitosSemanais = ref.watch(habitProvider).where((habit) => habit.frequencia == Frequencia.semanal).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Semanais'),
      ),
      body: habitosSemanais.isEmpty
          ? Center(child: Text('Nenhum hábito semanal encontrado.'))
          : ListView.builder(
        itemCount: habitosSemanais.length,
        itemBuilder: (context, index) {
          final habit = habitosSemanais[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(habitProvider.notifier).removeHabit(habit); // Remove o hábito
              },
            ),
            title: Text(habit.name),
            subtitle: Text('${habit.descricao}\nDias da semana: ${habit.days.join(', ')}\nDias completados: ${habit.completedDays.join(', ')}'), // Mostra os dias completados
            trailing: Checkbox(
              value: habit.isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  // Atualize o estado com base na marcação
                  ref.read(habitProvider.notifier).markHabitAsCompleted(
                      habit.copyWith(
                        isCompleted: value,
                        completedDays: value ? [...habit.completedDays, DateTime.now().day] : habit.completedDays,
                      )
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
