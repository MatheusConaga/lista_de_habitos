import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/screens/semanal.dart';
import 'package:monitoramento_de_habitos/screens/mensal.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/diario.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart'; // Import do provedor
import 'package:monitoramento_de_habitos/models/habit.dart'; // Importa o modelo Habit e Frequencia

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    // Calcular o progresso para Diário, Semanal e Mensal
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
          // Navegar para a tela de adicionar hábito
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

  // Função para calcular o progresso dos hábitos
  double _calcularProgresso(List<Habit> habits, Frequencia frequencia) {
    final totalHabits = habits.where((habit) => habit.frequencia == frequencia).toList();
    if (totalHabits.isEmpty) return 0.0;

    final completedHabits = totalHabits.where((habit) => habit.isCompleted).length;
    return completedHabits / totalHabits.length;
  }

  // Função para criar um Card com título e barra de progresso circular
  Widget _buildHabitCard(BuildContext context, String title, double percent) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Diário') {
            // Navegar para a tela Diário ao clicar em "Diário"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiarioScreen()),
            );
          } else if (title == 'Semanal') {
            // Navegar para a tela Semanal ao clicar em "Semanal"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SemanalScreen()),
            );
          } else if (title == 'Mensal') {
            // Navegar para a tela Mensal ao clicar em "Mensal"
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
                radius: 60.0, // Tamanho do círculo
                lineWidth: 8.0, // Largura da barra
                percent: percent, // Percentual de progresso
                center: Text(
                  '${(percent * 100).toInt()}%', // Exibe o percentual
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.green, // Cor da barra de progresso
                backgroundColor: Colors.grey.shade300, // Cor do fundo da barra
                circularStrokeCap: CircularStrokeCap.round, // Estilo da barra
              ),
            ],
          ),
        ),
      ),
    );
  }
}
