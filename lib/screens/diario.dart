import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class DiarioScreen extends ConsumerWidget {
  const DiarioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitosDiarios = ref.watch(habitProvider).where((habit) => habit.frequencia == Frequencia.diario).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Diários'),
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
