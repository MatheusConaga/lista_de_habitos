import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/semanal.dart';
import 'package:monitoramento_de_habitos/screens/mensal.dart';
import 'package:monitoramento_de_habitos/screens/diario.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Chama o provider para verificar e atualizar o estado do card de lembrete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reminderLogicProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final showReminderCard = ref.watch(reminderCardProvider);

    // Calcula o progresso para cada tipo de hábito
    final progressoDiario = _calcularProgresso(habits, Frequencia.diario);
    final progressoSemanal = _calcularProgresso(habits, Frequencia.semanal);
    final progressoMensal = _calcularProgresso(habits, Frequencia.mensal);

    // Filtra os hábitos de hoje para mostrar no card de lembrete
    final todayHabits = ref.watch(habitProvider.notifier).getTodayHabits(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento de Hábitos'),
        backgroundColor: Colors.blue, // Cor de fundo da AppBar
        foregroundColor: Colors.white, // Cor do texto da AppBar
        centerTitle: true, // Centraliza o título
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Exibe o Card de lembrete se houver tarefas
              if (showReminderCard && todayHabits.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.amber,
                    child: Stack(
                      children: [
                        ListTile(
                          leading: Icon(Icons.task),
                          title: Text('Tarefas de hoje'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: todayHabits.map((habit) {
                              return Text(
                                '${habit.name} (${habit.frequencia == Frequencia.diario ? 'Diário' : habit.frequencia == Frequencia.semanal ? 'Semanal' : 'Mensal'})',
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                          right: 8.0,
                          top: 8.0,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              // Oculta o card de lembrete
                              ref.read(reminderCardProvider.notifier).state = false;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Espaçamento reduzido entre os cartões
              _buildHabitCard(context, 'Diário', progressoDiario, Colors.blue),
              _buildHabitCard(context, 'Semanal', progressoSemanal, Colors.green),
              _buildHabitCard(context, 'Mensal', progressoMensal, Colors.orange),
              SizedBox(height: 80), // Espaçamento adicional para o botão de adicionar
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
        child: Icon(
          Icons.add,
          color: Colors.white, // Cor do ícone adicionar
        ),
        backgroundColor: Colors.blue, // Cor de fundo do botão
      ),
    );
  }

  double _calcularProgresso(List<Habit> habits, Frequencia frequencia) {
    final totalHabits = habits.where((habit) => habit.frequencia == frequencia).toList();
    if (totalHabits.isEmpty) return 0.0;
    final completedHabits = totalHabits.where((habit) => habit.isCompleted).length;
    return completedHabits / totalHabits.length;
  }

  Widget _buildHabitCard(BuildContext context, String title, double percent, Color cardColor) {
    return Card(
      color: cardColor, // Define a cor do cartão com base no parâmetro cardColor
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
                  color: Colors.white, // Texto branco
                ),
              ),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 8.0,
                percent: percent,
                center: Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto branco do progresso
                  ),
                ),
                progressColor: Colors.green[800], // Verde mais escuro para o progresso concluído
                backgroundColor: Colors.white,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
