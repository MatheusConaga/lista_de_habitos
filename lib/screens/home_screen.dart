import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart'; // Certifique-se de que este caminho está correto
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/semanal.dart';
import 'package:monitoramento_de_habitos/screens/mensal.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/diario.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final progressoDiario = _calcularProgresso(habits, Frequencia.diario);
    final progressoSemanal = _calcularProgresso(habits, Frequencia.semanal);
    final progressoMensal = _calcularProgresso(habits, Frequencia.mensal);

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento de Hábitos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHabitCard(context, 'Diário', progressoDiario),
              SizedBox(height: 16),
              _buildHabitCard(context, 'Semanal', progressoSemanal),
              SizedBox(height: 16),
              _buildHabitCard(context, 'Mensal', progressoMensal),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  double _calcularProgresso(List<Habit> habits, Frequencia frequencia) {
    final totalHabits = habits.where((habit) => habit.frequencia == frequencia).toList();
    if (totalHabits.isEmpty) return 0.0;
    final completedHabits = totalHabits.where((habit) => habit.isCompleted).length;
    return completedHabits / totalHabits.length;
  }

  Widget _buildHabitCard(BuildContext context, String title, double percent) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Diário') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiarioScreen()),
            );
          } else if (title == 'Semanal') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SemanalScreen()),
            );
          } else if (title == 'Mensal') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MensalScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 8.0,
                percent: percent,
                center: Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade300,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
