import 'package:flutter/material.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habito;

  const HabitDetailScreen({super.key, required this.habito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nome: ${habito.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Descrição: ${habito.descricao}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Frequência: ${habito.frequencia.name}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Adicione outros detalhes se necessário
          ],
        ),
      ),
    );
  }
}
