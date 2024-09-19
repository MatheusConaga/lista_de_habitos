import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class ReminderCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderCardState = ref.watch(reminderCardProvider);

    if (!reminderCardState) {
      return SizedBox.shrink();
    }

    // Obter os hábitos de hoje
    final today = DateTime.now();
    final todayHabits = ref.watch(habitProvider.notifier).getTodayHabits(today);

    if (todayHabits.isEmpty) {
      return SizedBox.shrink(); // Nenhum hábito encontrado, não exibe o card
    }

    // Vamos exibir todos os hábitos do dia, não apenas o primeiro
    return Column(
      children: todayHabits.map((habit) {
        return Card(
          margin: EdgeInsets.all(16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text('Lembrete de Tarefa'),
            subtitle: Text(
              'Tarefa: ${habit.name}\nFrequência: ${_getFrequenciaText(habit.frequencia)}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                ref.read(reminderCardProvider.notifier).state = false; // Oculta o card
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // Função para converter a enum Frequencia para texto legível
  String _getFrequenciaText(Frequencia frequencia) {
    switch (frequencia) {
      case Frequencia.diario:
        return 'Diário';
      case Frequencia.semanal:
        return 'Semanal';
      case Frequencia.mensal:
        return 'Mensal';
      default:
        return 'Desconhecido';
    }
  }
}
